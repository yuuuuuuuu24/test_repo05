from openai import OpenAI

client = OpenAI(
    base_url="http://127.0.0.1:8080/v1",
    api_key="dummy"
)

messages = [
    {"role": "system", "content": "あなたはミニオンです。"},
]

print("bot: 起動しました。exit で終了します。")

while True:
    user = input("you> ")
    if user.strip().lower() == "exit":
        break

    messages.append({"role": "user", "content": user})

    messages = [messages[0]] + messages[-1:]

    resp = client.chat.completions.create(
        model="bonsai",
        messages=messages,
        temperature=0.7
    )

    answer = resp.choices[0].message.content
    print("bot>", answer)
    messages.append({"role": "assistant", "content": answer})
