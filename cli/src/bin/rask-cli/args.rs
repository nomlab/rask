use chrono::{DateTime, Utc};
use clap::{ArgGroup, Parser};
use rask::task::TaskState;

#[derive(Debug, Parser)]
#[command(author, version, about)]
pub struct Args {
    /// API Key for communicate with Rask
    #[arg(short, long, required = true, env = "RASK_API_KEY", global = true)]
    pub api_key: String,

    /// API Key for communicate with Rask
    #[arg(short, long, required = true, env = "RASK_URL", global = true)]
    pub url: String,

    #[command(subcommand)]
    pub target: Target,
    // #[arg(short = 'n', long = "username",global=true)]
    // pub target_user: Option<String>,
}

#[derive(Debug, Parser)]
pub enum Target {
    /// Manage tasks
    #[command(subcommand)]
    Task(TaskAction),

    /// Manage documents
    #[command(subcommand)]
    Document(DocumentAction),

    /// Manage users
    #[command(subcommand)]
    User(UserAction),

    /// Manage projects
    #[command(subcommand)]
    Project(ProjectAction),
}

#[derive(Debug, Parser)]
pub enum TaskAction {
    /// Create new task
    Create(TaskCreateArgs),

    /// List tasks
    List(TaskListArgs),
}

#[derive(Debug, Parser)]
pub enum DocumentAction {
    /// List documents
    List(DocumentListArgs),
}

#[derive(Debug, Parser)]
pub enum UserAction {
    /// List users
    List(UserListArgs),
}

#[derive(Debug, Parser)]
pub enum ProjectAction {
    /// List projects
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
    #[arg(short = 't', long)]
    pub due_at: Option<String>,

    /// Description of new task. Ex: "Do something"
    #[arg(short, long)]
    pub description: Option<String>,
}

#[derive(Debug, Parser)]
pub struct TaskListArgs {
    #[command(flatten)]
    pub list: ListArgs,
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

    /// term duration.
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
