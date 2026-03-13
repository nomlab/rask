# rask-cli
CLI tool to manage Rask

## Install
You can install [release page](./releases/latest)

Or, build from source
1. Clone this repository
2. Install Rust
3. Build (`cargo build --release`)
4. You can install Binary (`./target/release/rask-cli`) to wherever you want

## Usage
* First, get Rask API token and set env variable
  ```bash
  $ export RASK_API_KEY="rask-thisissample-apitoken-012345679"
  $ export RASK_URL="https://rask.example.com"
  ```
  * Or, you must set above value when you run command
  ```bash
  $ rask-cli --api-key "rask-thisissample-apitoken-012345679" --url "https://rask.example.com" task list
  ```

* Show all Tasks / Users / Projects
  ```bash
  $ rask-cli task list
  $ rask-cli user list
  $ rask-cli projects list
  ```
* Create new Task
  ```bash
  $ ./rask-cli task create --title <TITLE> \
                           --assigner-name <ASSIGNER_NAME> \
                           --state <todo/done/someday> \
                           --project-name <PROJECT_NAME> \
                           --due_at <DATE> \
                           --description <DESCRIPTION>
  ```
  * Ex:
    ```bash
    $ rask-cli task create --title "Complete my measurement" \
                             --assigner-name "nomlab" \
                             --state todo \
                             --project-name "My Research" \
                             --due_at "2024-09-26" \
                             --description "See http://example.com for details"
    ```
* Show `rask-cli --help` for more details
