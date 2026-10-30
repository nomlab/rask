# rask-cli

CLI tool to manage Rask

## Overview

`rask-cli` is a Rust-based command line client for the Rask API. It provides commands to list Rask resources, create tasks, and search documents.

## Features

- List tasks, documents, users, and projects
- Create tasks from the command line
- Search documents by ID, keyword, creator, project, and date fields
- Output list results in JSON format
- Configure the Rask API key and server URL with environment variables or CLI options

## Install

Download a binary from the [release page](./releases/latest).

Or build from source:

1. Clone this repository.
2. Install Rust.
3. Build the binary.

```bash
cargo build --release
```

4. Install `./target/release/rask-cli` wherever you want.

## Quick Start

Set your Rask API credentials:

```bash
export RASK_API_KEY="rask-thisissample-apitoken-012345679"
export RASK_URL="https://rask.example.com"
```

List tasks:

```bash
rask-cli task list
```

Create a task:

```bash
rask-cli task create \
  --title "Complete my measurement" \
  --assigner-name "nomlab" \
  --state todo \
  --project-name "My Research" \
  --due-at "2024-09-26" \
  --description "See http://example.com for details"
```

## Authentication

`rask-cli` requires both an API key and a Rask server URL.

| Source | Example |
|---|---|
| Environment variables | `RASK_API_KEY="..." RASK_URL="..."` |
| CLI options | `--api-key "..." --url "..."` |

Using environment variables is recommended for everyday usage:

```bash
export RASK_API_KEY="rask-thisissample-apitoken-012345679"
export RASK_URL="https://rask.example.com"
```

You can also pass credentials for a single command:

```bash
rask-cli \
  --api-key "rask-thisissample-apitoken-012345679" \
  --url "https://rask.example.com" \
  task list
```

## Usage

### List Resources

```bash
rask-cli task list
rask-cli document list
rask-cli user list
rask-cli project list
```

| Command | Description |
|---|---|
| `task list` | List tasks |
| `document list` | List documents |
| `user list` | List users |
| `project list` | List projects |

### JSON Output

All `list` commands accept `--json` to print the results as pretty-printed JSON instead of the default debug format.

```bash
rask-cli task list --json
rask-cli document list --json
rask-cli user list --json
rask-cli project list --json
```

`--json` can be combined with document search options:

```bash
rask-cli document list --content "rust" "api" --json
```

### Filter Tasks by User

```bash
rask-cli task list --username "nomlab"
```

Only tasks whose assignee screen name exactly matches the given name are listed. If no user has that screen name, the command fails with `User not found`.

### Create Tasks

```bash
rask-cli task create \
  --title <TITLE> \
  --assigner-name <ASSIGNER_NAME> \
  --state <todo|done|someday> \
  --project-name <PROJECT_NAME> \
  --due-at <DATE> \
  --description <DESCRIPTION>
```

### Search Documents

```bash
rask-cli document list [OPTIONS]
```

Document search options can be combined. Keyword search options that receive multiple values use an AND condition.

```bash
rask-cli document list \
  --content "rust" "api" \
  --created-at "2024-09-26T00:00:00Z" \
  --term-duration 3
```

## Command Reference

### Global Options

| Option | Environment variable | Description |
|---|---|---|
| `-a, --api-key <API_KEY>` | `RASK_API_KEY` | API key for communicating with Rask |
| `-u, --url <URL>` | `RASK_URL` | Rask server URL |

### Subcommands

| Command | Description |
|---|---|
| `rask-cli task create [OPTIONS]` | Create a new task |
| `rask-cli task list [OPTIONS]` | List tasks |
| `rask-cli document list [OPTIONS]` | List documents, optionally searched |
| `rask-cli user list [OPTIONS]` | List users |
| `rask-cli project list [OPTIONS]` | List projects |

### `list` Common Options

The following option is available for `task list`, `document list`, `user list`, and `project list`.

| Option | Type | Description |
|---|---|---|
| `--json` | Flag | Output results in JSON format |

### `task list`

| Option | Type | Description |
|---|---|---|
| `-n, --username <USERNAME>` | String | Filter tasks by assignee screen name |

### `task create`

| Option | Type | Required | Description |
|---|---|---:|---|
| `--title <TITLE>` | String | Yes | Task title |
| `--assigner-name <ASSIGNER_NAME>` | String | Yes | Assignee screen name |
| `--state <STATE>` | `todo`, `done`, or `someday` | No | Task state. Defaults to `todo` |
| `--project-name <PROJECT_NAME>` | String | No | Project name |
| `--due-at <DATE>` | String | No | Due date sent to the server |
| `--description <DESCRIPTION>` | String | No | Task description |

### `document list`

| Option | Type | Description |
|---|---|---|
| `--id <ID>` | Integer | Search by document ID |
| `--content <KEYWORD>...` | String list | Search by keywords in content |
| `--creator-id <ID>` | Integer | Search by creator ID |
| `--creator-name <KEYWORD>...` | String list | Search by keywords in creator name |
| `--description <KEYWORD>...` | String list | Search by keywords in description |
| `--project-id <ID>` | Integer | Search by project ID |
| `--project-name <KEYWORD>...` | String list | Search by keywords in project name |
| `--created-at <DATE>` | RFC3339 timestamp | Search by created date |
| `--updated-at <DATE>` | RFC3339 timestamp | Search by updated date |
| `--start-at <DATE>` | RFC3339 timestamp | Search by start date |
| `--end-at <DATE>` | RFC3339 timestamp | Search by end date |
| `--term-duration <DAYS>` | Integer | Widen date search by +/- N days. Requires at least one date search option |

## Examples

### Create Task

```bash
rask-cli task create \
  --title "Complete my measurement" \
  --assigner-name "nomlab" \
  --state todo \
  --project-name "My Research" \
  --due-at "2024-09-26" \
  --description "See http://example.com for details"
```

### Search Documents by Content

```bash
rask-cli document list --content "rust" "api"
```

### Search Documents by Project

```bash
rask-cli document list --project-name "My Research"
```

### Search Documents by Content and Date

```bash
rask-cli document list \
  --content "rust" "api" \
  --created-at "2024-09-26T00:00:00Z" \
  --term-duration 3
```

### List Tasks as JSON

```bash
rask-cli task list --json
```

### List a User's Tasks as JSON

```bash
rask-cli task list --username "nomlab" --json
```

## Notes

### ID and Keyword Search

`<ID>` options accept non-negative integers only. Decimal numbers, negative numbers, and non-numeric text cause a parse error.

`<KEYWORD>` options accept one or more strings. When multiple keywords are given, only documents matching all keywords are returned.

### Date Formats

`document list` date search options are parsed as `DateTime<Utc>`, so they must use a full RFC3339 timestamp:

```bash
rask-cli document list --created-at "2024-09-26T00:00:00Z"
rask-cli document list --created-at "2024-09-26T09:00:00+09:00"
```

A date-only value such as `2024-09-26` will fail to parse.

### Term Duration

`--term-duration <DAYS>` widens the search window on both sides of each specified document date search option.

For example, `--created-at "2024-09-26T00:00:00Z" --term-duration 3` matches documents within 3 days before or after the specified timestamp.

`--term-duration` has no effect by itself and must be combined with at least one of:

- `--created-at`
- `--updated-at`
- `--start-at`
- `--end-at`

## Help

Use `--help` to see the latest CLI help generated from the command definitions:

```bash
rask-cli --help
rask-cli task --help
rask-cli document list --help
```
