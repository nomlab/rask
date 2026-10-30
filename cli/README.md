# README

[English](./README.en.md) | 日本語

## What is rask-cli?

* [Rask](../README.md) の API を利用してコマンドラインから Rask を操作できる CLI ツール

## Setup

1. リポジトリを clone し，ビルドする

   ```bash
   git clone https://github.com/nomlab/rask.git
   cd rask/cli
   cargo build --release
   ```

   `./target/release/rask-cli` を PATH の通った場所に置く．

2. Rask の API キーと URL を設定する

   ```bash
   export RASK_API_KEY="rask-thisissample-apitoken-012345679"
   export RASK_URL="https://rask.example.com"
   ```

   環境変数の代わりに `--api-key` / `--url` オプションでも指定できる．

   ```bash
   rask-cli --api-key "..." --url "https://rask.example.com" task list
   ```

## Usage

代表的なコマンド:

```bash
# タスク一覧
rask-cli task list

# 特定ユーザのタスクを JSON で表示
rask-cli task list --username "nomlab" --json

# タスク作成
rask-cli task create \
  --title "Complete my measurement" \
  --assigner-name "nomlab" \
  --project-name "My Research" \
  --due-at "2024-09-26"

# 本文に "rust" と "api" を含むドキュメントを検索
rask-cli document list --content "rust" "api"

# ユーザ・プロジェクト一覧
rask-cli user list
rask-cli project list
```

全コマンドとオプションの詳細は [docs/CommandLineHelp.md](./docs/CommandLineHelp.md) を参照．

## Development

### Build / Test

```bash
cargo build
cargo test
```

### Others

[docs/CommandLineHelp.md](./docs/CommandLineHelp.md) は，[clap-markdown](https://crates.io/crates/clap-markdown) を用いて `src/bin/rask-cli/args.rs` の引数定義から自動生成している．
引数やヘルプ文を変更した場合は，次のコマンドで再生成してからコミットする．

```bash
UPDATE_DOCS=1 cargo test
```

再生成を忘れると，`cargo test` が定義とドキュメントの不一致を検出して失敗する．
