#!/bin/zsh

# 設定ファイル トークン，変数を管理
FilePath_Config="./config.sh"

# 設定ファイル確認処理
if [ ! -f "${FilePath_Config}" ]; then
    echo "Error : file not found.\n"${FilePath_Config}""
    exit 1
fi
source "${FilePath_Config}"

echo "delete "${Install_Directory}"/notify_program_end ? [y/n]: "

# 入力処理
while true; do
    read -k 1 Result
    case "${Result}" in
        y)
          echo "\n:start delete."
          break
          ;;
        n)
          echo "\n:cancel delete."
          exit 0
          ;;
        *)
          echo "\n:again. y or n"
          ;;
    esac
done

# delete処理
# コマンドファイル シンボリックリンクの削除
unlink "${Install_Directory}/${File_Command}"
echo "success : "${Install_Directory}/${File_Command}""

# ディレクトリ notify_program_end の削除
rm -r "${Install_Directory}/notify_program_end"
echo "success : "${Install_Directory}"/notify_program_end"

# 本体ディレクトリ内 jsonファイル の削除
rm -r "${Main_Directory}/json"
echo "success : "${Main_Directory}"/json"
echo "done"