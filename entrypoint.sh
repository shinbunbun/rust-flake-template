#!/bin/sh
# ホストの docker ソケットがマウントされているか確認
if [ -S /var/run/docker.sock ]; then
  echo "Docker ソケットを検出しました。ビルドしたイメージをロードします…"
  docker load -i result || {
    echo "docker load に失敗しました。"
    exit 1
  }
else
  echo "Docker ソケットが見つかりません。docker load をスキップします。"
fi
