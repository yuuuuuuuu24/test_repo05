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
