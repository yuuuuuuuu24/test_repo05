# 1-bit Bonsai チャットシステムの使い方

このリポジトリでは，GitHub Codespaces 上で 1-bit Bonsai を動かし，Python の簡単なチャットプログラムから呼び出します。

## 1. 自分用のリポジトリを作る

まず，以下の見本リポジトリを開きます。

https://github.com/DevStudyAccount/1bit-Bonsai-System

画面右上付近に **Use this template** が表示されている場合は，それを押して，自分の GitHub アカウント上に新しいリポジトリを作成してください。

リポジトリ名は自由につけてかまいません。

例：

`my-bonsai-chat`

## 2. Codespaces を起動する

自分のリポジトリを開いた状態で，以下の操作をします。

1. 緑色の **Code** ボタンを押す
2. **Codespaces** タブを選ぶ
3. **Create codespace on main** を押す

しばらく待つと，ブラウザ上で VS Code のような画面が開きます。

この画面が，今回使う開発環境です。

## 3. チャットプログラムを起動する

Codespaces が開いたら，画面下のターミナルで次のコマンドを実行します。

```bash
bash bonsai_chat_1bit.sh
```

すると，使用する Bonsai のモデルサイズを聞かれます。

```text
使う 1-bit Bonsai のモデルサイズを選んでください: 1.7B / 4B / 8B
Enterだけなら 1.7B を使います
終了する場合は q を入力してください
```

最初はそのまま Enter を押して，`1.7B` を使ってください。

初回実行時は，Bonsai の取得や Python 環境の準備が行われるため，少し時間がかかります。

## 4. チャットする

準備が終わると，次のように表示されます。

```text
bot: 起動しました。exit で終了します。
you>
```

`you>` の後に文章を入力して Enter を押すと，Bonsai が返答します。

例：

```text
you> こんにちは
```

終了したいときは，次のように入力します。

```text
exit
```

## 5. 2回目以降の起動

2回目以降も，同じコマンドで起動できます。

```bash
bash bonsai_chat_1bit.sh
```

すでに Bonsai やモデルが取得済みの場合は，初回より短い時間で起動します。

## 6. 注意

Codespaces を停止しても，通常は作成したファイルや取得済みのモデルは残ります。

ただし，Codespace 自体を削除すると，その中に保存されていた Bonsai のモデルや仮想環境も消えます。その場合は，もう一度 `bash bonsai_chat_1bit.sh` を実行して準備し直してください。

また，Bonsai は Codespaces 上の CPU で動かすため，返答に時間がかかることがあります。

## 7. 使われている技術について

このリポジトリでは，主に **Docker**，**GitHub Codespaces**，**ローカルLLM** という技術を使っています。

### Docker

Docker は，開発に必要な環境をひとまとめにして用意するための技術です。

普通の開発では，学生ごとのパソコンに入っている Python や Node.js のバージョンが違ったり，必要なソフトが入っていなかったりして，「先生の環境では動くが，自分の環境では動かない」ということが起こります。

Docker を使うと，あらかじめ決められた環境をもとに開発環境を作ることができます。

このリポジトリでは，`.devcontainer/Dockerfile` に，開発環境に入れておきたいソフトを記述しています。

たとえば，このリポジトリでは以下のようなものを事前に入れています。

- Node.js
- Gemini CLI
- uv

これにより，Codespaces を起動した時点で，授業に必要な道具がある程度そろった状態になります。

### GitHub Codespaces

GitHub Codespaces は，GitHub 上のリポジトリをもとに，ブラウザ上で使える開発環境を作るサービスです。

自分のパソコンに Python や Node.js を直接インストールしなくても，GitHub 上に用意された開発環境でプログラムを動かせます。

このリポジトリでは，Codespaces を起動すると，`.devcontainer` フォルダ内の設定をもとに開発環境が作られます。

### ローカルLLM

LLM は Large Language Model の略で，大規模言語モデルと呼ばれます。

ChatGPT のように，文章を入力すると，それに続く自然な文章を生成するモデルです。

多くの生成AIサービスでは，入力した文章をインターネット経由で外部のサーバに送り，クラウド上のAIが返答を生成します。

一方で，**ローカルLLM** は，自分の環境の中でモデルを動かします。

今回の場合は，Codespaces 上に Bonsai のモデルをダウンロードし，その中で LLM サーバを起動しています。

つまり，今回の構成では，次のような流れでチャットが動きます。

1. Bonsai のモデルを Codespaces 内に置く
2. Bonsai のサーバを Codespaces 内で起動する
3. Python の `interface.py` から Bonsai サーバに質問を送る
4. Bonsai サーバが返答を生成する

### Python プログラムと Bonsai サーバの関係

`interface.py` は，LLM そのものではありません。

`interface.py` は，起動している Bonsai サーバに文章を送り，返ってきた答えを画面に表示するプログラムです。

そのため，Bonsai サーバが起動していない状態で `interface.py` だけを動かしても，チャットはできません。

このリポジトリでは，`bonsai_chat_1bit.sh` が以下の処理をまとめて行います。

- Bonsai の取得
- Python 仮想環境の準備
- 必要な Python ライブラリの準備
- Bonsai サーバの起動
- `interface.py` の起動

そのため，利用者は基本的に次のコマンドだけでチャットを開始できます。

```bash
bash bonsai_chat_1bit.sh
```

### 今回のシステムの全体像

今回のシステムは，次のような構成です。

```text
GitHub リポジトリ
  ↓
GitHub Codespaces
  ↓
Docker によって作られた開発環境
  ↓
Bonsai ローカルLLMサーバ
  ↓
Python の interface.py
  ↓
チャット画面
```

つまり，GitHub 上のリポジトリをもとに Codespaces を作り，その中で Docker による開発環境を使い，さらにその中でローカルLLMである Bonsai を動かしています。
