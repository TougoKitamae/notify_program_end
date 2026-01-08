#!/bin/zsh

# 引数処理
TOKEN=$1            # slackAPI 認証トークン
Program=$2          # 監視対象のプログラム名
Channel_ID=$3       # slack通知 送信先チャンネルID
User_ID=$4          # slack通知 メンションのユーザーID デフォルトは空
Error_Log=$5        # 本プログラム，curlコマンド エラーログ ファイルパス

# 引数エラー処理
if [ -z "${TOKEN}" ] || [ -z "${Program}" ] || [ -z "${Channel_ID}" ]; then
    echo "Error : missing required argument."
    exit 1
fi

# 標準エラー，終了コード 一時保存用ファイル作成
tmp_std_error=$(mktemp)                 # 標準エラー
tmp_status_program=$(mktemp)            # 終了コード

# プログラム実行 終了コード及び，標準エラー取得
{
    ./"${Program}" 2> "${tmp_std_error}"
    echo $? > "${tmp_status_program}"
} &
wait

Stderr=$(< "${tmp_std_error}")           # 標準エラー格納変数 正常終了なら空
Exit_Code=$(< "${tmp_status_program}")    # 終了コード格納変数 0 or 1

# 一時保存用ファイル削除
rm "${tmp_std_error}" "${tmp_status_program}"

# メンション機能処理
Mention=""                              # ${User_ID}が空の場合は空
if [ -n "${User_ID}" ]; then
    Mention="<@${User_ID}>"
fi

# 送信メッセージ作成
Message=$'\n'"プログラム終了(テスト)"$'\n'"プログラム : ${Program}"$'\n'

# 実行結果のメッセージ作成
if [ "${Exit_Code}" -ne 0 ]; then
    Result="エラー終了 : ${Stderr}"
else
    Result="正常終了"
fi

# slack送信処理 jsonエンコード
Contents=$(jq -n --arg channel "${Channel_ID}" --arg text "${Mention}${Message}${Result}" '{ channel: $channel, text: $text}')

curl -v -s -X POST "https://slack.com/api/chat.postMessage" \
     -H "Content-Type: application/json; charset=utf-8" \
     -H "Authorization: Bearer ${TOKEN}" \
     -d "${Contents}"  > "${Error_Log}"

exit 0