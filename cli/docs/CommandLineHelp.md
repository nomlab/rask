# Command-Line Help for `rask`

This document contains the help content for the `rask` command-line program.

**Command Overview:**

* [`rask`↴](#rask)
* [`rask task`↴](#rask-task)
* [`rask task create`↴](#rask-task-create)
* [`rask task list`↴](#rask-task-list)
* [`rask document`↴](#rask-document)
* [`rask document list`↴](#rask-document-list)
* [`rask user`↴](#rask-user)
* [`rask user list`↴](#rask-user-list)
* [`rask project`↴](#rask-project)
* [`rask project list`↴](#rask-project-list)

## `rask`

Library for communicate with Rask

**Usage:** `rask [OPTIONS] <COMMAND>`

###### **Subcommands:**

* `task` — Manage tasks
* `document` — Manage documents
* `user` — Manage users
* `project` — Manage projects

###### **Options:**

* `-a`, `--api-key <API_KEY>` — API Key for communicate with Rask
* `-u`, `--url <URL>` — URL of the Rask server



## `rask task`

Manage tasks

Create new tasks or list existing tasks on Rask.

**Usage:** `rask task <COMMAND>`

###### **Subcommands:**

* `create` — Create new task
* `list` — List tasks



## `rask task create`

Create new task

Register a new task on Rask. The assigner and project are given by name and resolved to their IDs before the task is saved. The state defaults to "todo" when omitted.

**Usage:** `rask task create [OPTIONS] --title <TITLE> --assigner-name <ASSIGNER_NAME>`

###### **Options:**

* `-t`, `--title <TITLE>` — Title for new task. Ex: "Awesome Task"
* `-s`, `--state <STATE>` — State of new task

  Default value: `todo`

  Possible values: `todo`, `done`, `someday`

* `-a`, `--assigner-name <ASSIGNER_NAME>` — Assigner name of new task. Ex: "john"
* `-p`, `--project-name <PROJECT_NAME>` — Project name that new task is assigned. Ex: "Grateful project"
* `--due-at <DUE_AT>` — Dead line of new task. Ex: "2036/2/6" or "2036-2-6"
* `-d`, `--description <DESCRIPTION>` — Description of new task. Ex: "Do something"



## `rask task list`

List tasks

Fetch all tasks from Rask and print them. Use --username to show only tasks assigned to that user, and --json to print them as pretty JSON.

**Usage:** `rask task list [OPTIONS]`

###### **Options:**

* `--json` — Output in JSON format
* `-n`, `--username <USERNAME>` — Show only tasks assigned to this user (screen name). Ex: "john"



## `rask document`

Manage documents

List and search documents on Rask.

**Usage:** `rask document <COMMAND>`

###### **Subcommands:**

* `list` — List documents



## `rask document list`

List documents

Fetch all documents from Rask and print the ones matching every given filter. Keyword filters (--content, --description, --creator-name, --project-name) accept multiple values and match only when all keywords are contained. Date filters (--created-at, --updated-at, --start-at, --end-at) match documents within ±--term-duration days of the given date (exact match by default).

**Usage:** `rask document list [OPTIONS]`

###### **Options:**

* `--json` — Output in JSON format
* `--id <ID>` — Filter by document ID
* `-c`, `--content <CONTENT>` — Filter by keywords in content (Ex: "rust", "api")
* `--creator-id <CREATOR_ID>` — Filter by creator ID
* `--creator-name <CREATOR_NAME>` — Filter by creator name
* `--description <DESCRIPTION>` — Filter by keywords in description (Ex: "rust", "api")
* `--project-id <PROJECT_ID>` — Filter by project ID
* `--project-name <PROJECT_NAME>` — Filter by project name
* `--created-at <CREATED_AT>` — Filter by created_at. Ex: "2036/2/6" or "2036-2-6"
* `--updated-at <UPDATED_AT>` — Filter by updated_at. Ex: "2036/2/6" or "2036-2-6"
* `--start-at <START_AT>` — Filter by start_at. Ex: "2036/2/6" or "2036-2-6"
* `--end-at <END_AT>` — Filter by end_at. Ex: "2036/2/6" or "2036-2-6"
* `--term-duration <TERM_DURATION>` — Allowed range in days around the date filters. Ex: 3 matches ±3 days



## `rask user`

Manage users

List users registered on Rask.

**Usage:** `rask user <COMMAND>`

###### **Subcommands:**

* `list` — List users



## `rask user list`

List users

Fetch all users from Rask and print them. Use --json to print them as pretty JSON.

**Usage:** `rask user list [OPTIONS]`

###### **Options:**

* `--json` — Output in JSON format



## `rask project`

Manage projects

List projects registered on Rask.

**Usage:** `rask project <COMMAND>`

###### **Subcommands:**

* `list` — List projects



## `rask project list`

List projects

Fetch all projects from Rask and print them. Use --json to print them as pretty JSON.

**Usage:** `rask project list [OPTIONS]`

###### **Options:**

* `--json` — Output in JSON format



<hr/>

<small><i>
    This document was generated automatically by
    <a href="https://crates.io/crates/clap-markdown"><code>clap-markdown</code></a>.
</i></small>
