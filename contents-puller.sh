#!/bin/bash
# 最新WebコンテンツをGitHubからコンテナへ取込む
# コンテンツ元の環境変数が無ければエラーで終了
if [ -z $CONTENTS_SOURCE_URL ]; then
   exit 1
fi
# 初回は GitLab からコンテンツをクローンする
git clone $CONTENTS_SOURCE_URL /data
# 2 回目以降は、1 分ごとに変更差分を取得する
cd /data
while true
do
   date
   sleep 60
   git pull
done