# rust-flake-template

## init

- 最初に`make init`を実行してください（ディレクトリのbasenameからプロジェクト名が設定されます）
- ディレクトリ名を変えた場合も同様に実行してください

## devShell

```shell
nix develop
```

### direnvを使う場合

- `.envrc`を作り、`use flake`と記述
- `direnv allow`を実行

## Docker, devcontainerを使う場合

```shell
make dev-env
```

を実行し、devcontainerを開く

## 依存関係の追加について

- Dockerで使いたい依存関係はflake.nixの`copyToRoot.path`に書く
- devShellで使いたいものは`devShell.packages`に
