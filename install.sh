#!/bin/zsh

# 設定ファイル トークン，変数を管理
FilePath_Config="./config.sh"

# 設定ファイル確認処理
if [ ! -f "${FilePath_Config}" ]; then
    echo "Error : file not found.\n"${FilePath_Config}""
    exit 1
fi
source "${FilePath_Config}"

# ディレクトリ確認処理 jsonファイル
if [ ! -d "${Main_Directory}/json" ] ; then
    mkdir "${Main_Directory}/json"
fi

# slackAPI メッセージ送信用 チャンネル名，IDの jsonファイル作成
curl -s -X GET -H "Authorization: Bearer ${TOKEN}" https://slack.com/api/conversations.list \
    | jq '.channels | map({ name: .name_normalized, id: .id })' > "${FilePath_Channel_Inf_MainDir}"
Result=$?

# 失敗時のエラー処理
if [ "$Result" -ne 0 ]; then
    echo "Error : failed to make file."
    echo "File : "${FilePath_Channel_Inf_MainDir}""
    echo "curl error : exit code= "${Result}""
    exit 1
fi
echo "success : "${FilePath_Channel_Inf_MainDir}""

# slackAPI メンション用 ユーザー名，ID jsonファイル作成
curl -s -X GET -H "Authorization: Bearer ${TOKEN}" https://slack.com/api/users.list \
    | jq '.members | map({ name: .real_name, id: .id })' > "${FilePath_User_Inf_MainDir}"
Result=$?

# 失敗時のエラー処理
if [ "$Result" -ne 0 ]; then
    echo "Error : failed to make file."
    echo "File : "${FilePath_User_Inf_MainDir}""
    echo "curl error : exit code= "${Result}""
    exit 1
fi
echo "success : "${FilePath_User_Inf_MainDir}""

# ディレクトリ確認処理 インストール先
if [ ! -d "${Install_Directory}" ] ; then
    mkdir "${Install_Directory}"
fi

# 本体ディレクトリ を インストール先にコピー
#cp -r "${Main_Directory}" ls"${Install_Directory}"
rsync -a --exclude='.git/' "${Main_Directory}" "${Install_Directory}/"

cd "${Install_Directory}/notify_program_end"
ln -snf "${Install_Directory}/notify_program_end/${File_Command}" "${Install_Directory}/${File_Command}"

# 設定ファイルへの記述案内
echo "add the following scripts to ~/.zshenv."
echo "export PATH=${Install_Directory/#$HOME/~}:\$PATH"
echo "done"
exit 0