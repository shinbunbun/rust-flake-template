# ベースイメージとして公式の nixos/nix を使用
FROM nixos/nix:latest

RUN mkdir -p /root/.config/nix && \
    echo "experimental-features = nix-command flakes" > /root/.config/nix/nix.conf

# Docker クライアントを Nix パッケージからインストール
RUN nix-env -iA nixpkgs.docker

# 作業ディレクトリを設定
WORKDIR /src

# プロジェクトの全ファイル（flake.nix 等）をイメージにコピー
COPY . .

# flake の dockerImage 出力をビルド（シンボリックリンク result が生成される）
RUN nix build -o result

# エントリーポイントスクリプトをコンテナ内にコピー
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# エントリーポイントを設定（必要に応じて CMD も変更）
ENTRYPOINT ["/entrypoint.sh"]
# CMD ["/bin/bash"]
