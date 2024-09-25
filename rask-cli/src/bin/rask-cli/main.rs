mod args;

use anyhow::{Context, Result};
use args::*;
use clap::Parser;
use rask::project::*;
use rask::task::*;
use rask::user::*;
use rask::Rask;

fn main() -> Result<()> {
    let args = Args::parse();

    Rask::init(args.url, args.api_key);

    match args.target {
        Target::Task(action) => match action {
            TaskAction::Create(args) => {
                let new_task = TaskRequest::new(
                    args.title,
                    args.state,
                    args.assigner_name,
                    args.project_name,
                    args.due_at,
                    args.description,
                )
                .context("Failed to create new task")?;
                Task::save(new_task).context("Failed to save new task")?;
                println!("Success to add new task");
            }
            TaskAction::List => {
                let tasks = Task::list().context("Failed to get Task list")?;
                for task in tasks {
                    println!("{:?}", task);
                }
            }
        },
        Target::User(action) => match action {
            UserAction::List => {
                let users = User::list().context("Failed to get User list")?;
                for user in users {
                    println!("{:?}", user);
                }
            }
        },
        Target::Project(action) => match action {
            ProjectAction::List => {
                let projects = Project::list().context("Failed to get Project list")?;
                for project in projects {
                    println!("{:?}", project);
                }
            }
        },
    }

    Ok(())
}
