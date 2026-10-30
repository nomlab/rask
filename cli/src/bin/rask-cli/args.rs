use chrono::{DateTime, Utc};
use clap::{ArgGroup, Parser};
use rask::task::TaskState;

#[derive(Debug, Parser)]
#[command(author, version, about)]
pub struct Args {
    /// API Key for communicate with Rask
    #[arg(short, long, env = "RASK_API_KEY", global = true, required = false)]
    pub api_key: String,

    /// URL of the Rask server
    #[arg(short, long, env = "RASK_URL", global = true, required = false)]
    pub url: String,

    #[command(subcommand)]
    pub target: Target,
    // #[arg(short = 'n', long = "username",global=true)]
    // pub target_user: Option<String>,
}

#[derive(Debug, Parser)]
pub enum Target {
    /// Manage tasks
    ///
    /// Create new tasks or list existing tasks on Rask.
    #[command(subcommand)]
    Task(TaskAction),

    /// Manage documents
    ///
    /// List and search documents on Rask.
    #[command(subcommand)]
    Document(DocumentAction),

    /// Manage users
    ///
    /// List users registered on Rask.
    #[command(subcommand)]
    User(UserAction),

    /// Manage projects
    ///
    /// List projects registered on Rask.
    #[command(subcommand)]
    Project(ProjectAction),
}

#[derive(Debug, Parser)]
pub enum TaskAction {
    /// Create new task
    ///
    /// Register a new task on Rask. The assigner and project are given by name
    /// and resolved to their IDs before the task is saved.
    /// The state defaults to "todo" when omitted.
    Create(TaskCreateArgs),

    /// List tasks
    ///
    /// Fetch all tasks from Rask and print them.
    /// Use --username to show only tasks assigned to that user,
    /// and --json to print them as pretty JSON.
    List(TaskListArgs),
}

#[derive(Debug, Parser)]
pub enum DocumentAction {
    /// List documents
    ///
    /// Fetch all documents from Rask and print the ones matching every given filter.
    /// Keyword filters (--content, --description, --creator-name, --project-name)
    /// accept multiple values and match only when all keywords are contained.
    /// Date filters (--created-at, --updated-at, --start-at, --end-at) match
    /// documents within ±--term-duration days of the given date (exact match by default).
    List(DocumentListArgs),
}

#[derive(Debug, Parser)]
pub enum UserAction {
    /// List users
    ///
    /// Fetch all users from Rask and print them.
    /// Use --json to print them as pretty JSON.
    List(UserListArgs),
}

#[derive(Debug, Parser)]
pub enum ProjectAction {
    /// List projects
    ///
    /// Fetch all projects from Rask and print them.
    /// Use --json to print them as pretty JSON.
    List(ProjectListArgs),
}

#[derive(Debug, Parser)]
pub struct ListArgs {
    /// Output in JSON format
    #[arg(long)]
    pub json: bool,
}

#[derive(Debug, Parser)]
pub struct TaskCreateArgs {
    /// Title for new task. Ex: "Awesome Task"
    #[arg(short, long)]
    pub title: String,

    /// State of new task.
    #[arg(short, long, default_value = "todo")]
    pub state: TaskState,

    /// Assigner name of new task. Ex: "john"
    #[arg(short, long)]
    pub assigner_name: String,

    /// Project name that new task is assigned. Ex: "Grateful project"
    #[arg(short, long)]
    pub project_name: Option<String>,

    /// Dead line of new task. Ex: "2036/2/6" or "2036-2-6"
    #[arg(long)]
    pub due_at: Option<String>,

    /// Description of new task. Ex: "Do something"
    #[arg(short, long)]
    pub description: Option<String>,
}

#[derive(Debug, Parser)]
pub struct TaskListArgs {
    #[command(flatten)]
    pub list: ListArgs,
    /// Show only tasks assigned to this user (screen name). Ex: "john"
    #[arg(short = 'n', long = "username")]
    pub username: Option<String>,
}

#[derive(Debug, Parser)]
#[command(group(
    ArgGroup::new("date_filter")
        .args(["created_at", "updated_at", "start_at", "end_at"])
        .multiple(true)
))]
pub struct DocumentListArgs {
    #[command(flatten)]
    pub list: ListArgs,

    /// Filter by document ID
    #[arg(long)]
    pub id: Option<usize>,

    /// Filter by keywords in content (Ex: "rust", "api")
    #[arg(short, long, num_args = 1..)]
    pub content: Option<Vec<String>>,

    /// Filter by creator ID
    #[arg(long)]
    pub creator_id: Option<usize>,

    /// Filter by creator name
    #[arg(long, num_args = 1..)]
    pub creator_name: Option<Vec<String>>,

    /// Filter by keywords in description (Ex: "rust", "api")
    #[arg(long, num_args = 1..)]
    pub description: Option<Vec<String>>,

    /// Filter by project ID
    #[arg(long)]
    pub project_id: Option<usize>,

    /// Filter by project name
    #[arg(long, num_args = 1..)]
    pub project_name: Option<Vec<String>>,

    /// Filter by created_at. Ex: "2036/2/6" or "2036-2-6"
    #[arg(long)]
    pub created_at: Option<DateTime<Utc>>,

    /// Filter by updated_at. Ex: "2036/2/6" or "2036-2-6"
    #[arg(long)]
    pub updated_at: Option<DateTime<Utc>>,

    /// Filter by start_at. Ex: "2036/2/6" or "2036-2-6"
    #[arg(long)]
    pub start_at: Option<DateTime<Utc>>,

    /// Filter by end_at. Ex: "2036/2/6" or "2036-2-6"
    #[arg(long)]
    pub end_at: Option<DateTime<Utc>>,

    /// Allowed range in days around the date filters. Ex: 3 matches ±3 days
    #[arg(long, requires = "date_filter")]
    pub term_duration: Option<usize>,
}

#[derive(Debug, Parser)]
pub struct UserListArgs {
    #[command(flatten)]
    pub list: ListArgs,
}

#[derive(Debug, Parser)]
pub struct ProjectListArgs {
    #[command(flatten)]
    pub list: ListArgs,
}

#[cfg(test)]
mod tests {
    use super::Args;

    #[test]
    fn command_line_help_is_up_to_date() {
        let path = concat!(env!("CARGO_MANIFEST_DIR"), "/docs/CommandLineHelp.md");
        let expected = clap_markdown::help_markdown::<Args>();

        if std::env::var_os("UPDATE_DOCS").is_some() {
            std::fs::create_dir_all(std::path::Path::new(path).parent().unwrap()).unwrap();
            std::fs::write(path, &expected).unwrap();
            return;
        }

        let actual = std::fs::read_to_string(path).unwrap_or_default();
        assert_eq!(
            actual, expected,
            "docs/CommandLineHelp.md が古いです。`UPDATE_DOCS=1 cargo test` で更新してください"
        );
    }
}
