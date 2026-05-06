#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BONSAI_DIR="$ROOT_DIR/.bonsai/Bonsai-demo"
SERVER_LOG="$ROOT_DIR/bonsai_server.log"

while true; do
  echo "使う 1-bit Bonsai のモデルサイズを選んでください: 1.7B / 4B / 8B"
  echo "Enterだけなら 1.7B を使います"
  echo "終了する場合は q を入力してください"
  read -r MODEL_SIZE

  if [ -z "$MODEL_SIZE" ]; then
    MODEL_SIZE="1.7B"
  fi

  case "$MODEL_SIZE" in
    1.7B|4B|8B)
      break
      ;;
    q|quit|exit)
      echo "終了します"
      exit 0
      ;;
    *)
      echo "想定外の入力です。もう一度入力してください。"
      ;;
  esac
done

if ! command -v uv >/dev/null 2>&1; then
  echo "uv が見つかりません。Codespace の作成に失敗している可能性があります。"
  exit 1
fi

if [ ! -f "$ROOT_DIR/interface.py" ]; then
  echo "interface.py が見つかりません。リポジトリ直下に置いてください。"
  exit 1
fi

mkdir -p "$ROOT_DIR/.bonsai"

if [ ! -d "$BONSAI_DIR" ]; then
  echo "Bonsai-demo を取得します。"
  git clone --depth 1 https://github.com/PrismML-Eng/Bonsai-demo.git "$BONSAI_DIR"
  rm -rf "$BONSAI_DIR/.git"
fi

cd "$BONSAI_DIR"

if [ ! -d .venv ]; then
  echo "Python仮想環境を作成します。"
  uv venv
fi

source .venv/bin/activate

export BONSAI_MODEL="$MODEL_SIZE"

SERVER_BIN="$BONSAI_DIR/bin/cpu/llama-server"

MODEL_PATH="$(find "$BONSAI_DIR" -name "Bonsai-${MODEL_SIZE}*.gguf" 2>/dev/null | head -n 1)"

if [ -x "$SERVER_BIN" ] && [ -n "$MODEL_PATH" ]; then
  echo "Bonsai ${MODEL_SIZE} はすでに存在します。セットアップをスキップします。"
else
  echo "Bonsai ${MODEL_SIZE} をセットアップします。"
  ./setup.sh
fi

# setup.sh が依存関係を入れ替えることがあるため、最後に openai を確認する
if ! python3 -c "import openai" >/dev/null 2>&1; then
  echo "openai ライブラリをインストールします。"
  uv pip install openai
fi

MODEL_PATH="$(find "$BONSAI_DIR" -name "Bonsai-${MODEL_SIZE}*.gguf" 2>/dev/null | head -n 1)"

if [ -z "$MODEL_PATH" ]; then
  echo "Bonsai ${MODEL_SIZE} のモデルファイルが見つかりませんでした。"
  exit 1
fi

if [ ! -x "$SERVER_BIN" ]; then
  echo "llama-server が見つかりません。Bonsai のセットアップに失敗している可能性があります。"
  exit 1
fi

echo "1-bit Bonsai サーバを起動します: $MODEL_PATH"

export LD_LIBRARY_PATH="$(dirname "$SERVER_BIN"):${LD_LIBRARY_PATH:-}"

"$SERVER_BIN" \
  -m "$MODEL_PATH" \
  -c 4096 \
  --host 127.0.0.1 \
  --port 8080 \
  > "$SERVER_LOG" 2>&1 &

SERVER_PID=$!

cleanup() {
  kill "$SERVER_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "モデル読み込み中です。少し待ちます。"

READY=0
for i in $(seq 1 120); do
  if curl -fsS http://127.0.0.1:8080/health >/dev/null 2>&1; then
    READY=1
    break
  fi
  sleep 2
done

if [ "$READY" -ne 1 ]; then
  echo "Bonsai サーバの起動確認に失敗しました。"
  echo "ログ: $SERVER_LOG"
  exit 1
fi

echo "Bonsai サーバが起動しました。対話プログラムを開始します。"

python3 "$ROOT_DIR/interface.py"
