use clap::Parser;
use rask::task::TaskState;

#[derive(Debug, Parser)]
#[command(author, version, about)]
pub struct Args {
    /// API Key for communicate with Rask
    #[arg(short, long, required = true, env = "RASK_API_KEY")]
    pub api_key: String,

    /// API Key for communicate with Rask
    #[arg(short, long, required = true, env = "RASK_URL")]
    pub url: String,

    #[command(subcommand)]
    pub target: Target,
}

#[derive(Debug, Parser)]
pub enum Target {
    /// Manage tasks
    #[command(subcommand)]
    Task(TaskAction),

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
    List,
}

#[derive(Debug, Parser)]
pub enum UserAction {
    /// List users
    List,
}

#[derive(Debug, Parser)]
pub enum ProjectAction {
    /// List projects
    List,
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
