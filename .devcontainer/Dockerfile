ARG PROJECT_NAME=none

FROM ${PROJECT_NAME}:latest AS base

# ベースイメージとして既存の rust-flake-template:latest を利用する
FROM rust-flake-template:latest

# 例: コンテナ内で dev 用ユーザー (dev) を作成する
# （※あらかじめ image 内に bash 等があることを前提とする）
RUN useradd -m -s /bin/bash dev

# 作業ディレクトリは /workspace とする（Makefileでマウントしたディレクトリと一致させる）
WORKDIR /workspace

# 必要ならパッケージの更新や追加のインストール（例：sudo や git など）
# RUN apt-get update && apt-get install -y sudo git

# ビルド済みイメージを元にしているので、基本的なツール（cargo, rustcなど）は利用可能である前提
# なお、ユーザー切り替え前にパッケージをインストールするか、ユーザー切り替え後にコマンドを実行するか注意してください

# 非 root ユーザーを dev に設定
USER dev
