# README

English | [日本語](./README.md)

## What is rask-cli?

* A CLI tool to operate [Rask](../README.md) from the command line via the Rask API

## Setup

1. Clone the repository and build

   ```bash
   git clone https://github.com/nomlab/rask.git
   cd rask/cli
   cargo build --release
   ```

   Put `./target/release/rask-cli` somewhere on your PATH.

2. Set the Rask API key and URL

   ```bash
   export RASK_API_KEY="rask-thisissample-apitoken-012345679"
   export RASK_URL="https://rask.example.com"
   ```

   Instead of environment variables, you can also use the `--api-key` / `--url` options.

   ```bash
   rask-cli --api-key "..." --url "https://rask.example.com" task list
   ```

## Usage

Common commands:

```bash
# List tasks
rask-cli task list

# Show a specific user's tasks as JSON
rask-cli task list --username "nomlab" --json

# Create a task
rask-cli task create \
  --title "Complete my measurement" \
  --assigner-name "nomlab" \
  --project-name "My Research" \
  --due-at "2024-09-26"

# Search documents whose content contains "rust" and "api"
rask-cli document list --content "rust" "api"

# List users and projects
rask-cli user list
rask-cli project list
```

See [docs/CommandLineHelp.md](./docs/CommandLineHelp.md) for details on all commands and options.

## Development

### Build / Test

```bash
cargo build
cargo test
```

### Others

[docs/CommandLineHelp.md](./docs/CommandLineHelp.md) is generated automatically from the argument definitions in `src/bin/rask-cli/args.rs` using [clap-markdown](https://crates.io/crates/clap-markdown).
When you change arguments or help text, regenerate it with the following command before committing.

```bash
UPDATE_DOCS=1 cargo test
```

If you forget to regenerate it, `cargo test` detects the mismatch between the definitions and the document and fails.
