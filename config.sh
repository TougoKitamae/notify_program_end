#!/bin/zsh

# slack API 認証トークン
TOKEN="XXXX"    # 各自設定

# 変数宣言
Install_Directory="$HOME/bin"         # コマンド，本ディレクトリ インストール場所
Main_Directory=$(pwd)                 # 本体ディレクトリ配置場所
File_Command=notice                   # コマンドファイル名

# インストール先のディレクトリからのパス
FilePath_User_Inf_InsDir="${Install_Directory}/notify_program_end/json/user_inf.json"           # slackAPI メンション用 ユーザー名，ID 格納ファイル
FilePath_Channel_Inf_InsDir="${Install_Directory}/notify_program_end/json/channel_inf.json"     # slackAPI メッセージ送信用 チャンネル名，ID 格納ファイル
FilePath_Process_Notice="${Install_Directory}/notify_program_end/process_notice.sh"             # 対象プログラムの 実行，終了判定，slack通知の実行ファイル
FilePath_Error_Log="${Install_Directory}/notify_program_end/error.log"                          # process_notice.sh のエラーログファイル
# 本体ディレクトリからのパス
FilePath_User_Inf_MainDir="${Main_Directory}/json/user_inf.json"                                # slackAPI メンション用 ユーザー名，ID 格納ファイル
FilePath_Channel_Inf_MainDir="${Main_Directory}/json/channel_inf.json"                          # slackAPI メッセージ送信用 チャンネル名，ID 格納ファイル