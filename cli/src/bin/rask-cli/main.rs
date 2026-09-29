mod args;
mod utils;

use anyhow::{Context, Result};
use args::*;
use clap::Parser;
use rask::document::*;
use rask::project::*;
use rask::task::*;
use rask::user::*;
use rask::Rask;
use crate::utils::filter_tasks_by_user;


fn print_json<T: serde::Serialize>(data: &T) -> Result<()> {
    println!("{}", serde_json::to_string_pretty(data)?);
    Ok(())
}

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
            TaskAction::List(args) => {
                let mut tasks = Task::list().context("Failed to get Task list")?;
                if let Some(target_user) = &args.username {
                    tasks = filter_tasks_by_user(tasks, target_user)?;
                } 
                if args.list.json {
                    print_json(&tasks)?;
                } else {
                    for task in &tasks {
                        println!("{:?}", task);
                    }
                }
            }
        },
        Target::Document(action) => match action {
            DocumentAction::List(args) => {
                let documents = Document::list().context("Failed to get Document list")?;

                let searched_documents = Document::search(
                    &documents,
                    args.id,
                    args.content.as_deref(),
                    args.creator_id,
                    args.creator_name.as_deref(),
                    args.description.as_deref(),
                    args.project_id,
                    args.project_name.as_deref(),
                    args.created_at,
                    args.updated_at,
                    args.start_at,
                    args.end_at,
                    args.term_duration,
                )
                .context("Failed to search documents")?;

                if args.list.json {
                    print_json(&searched_documents)?;
                } else {
                    for document in searched_documents {
                        println!("{:?}", document);
                    }
                }
            }
        },
        Target::User(action) => match action {
            UserAction::List(args) => {
                let users = User::list().context("Failed to get User list")?;
                if args.list.json {
                    print_json(&users)?;
                } else {
                    for user in users {
                        println!("{:?}", user);
                    }
                }
            }
        },
        Target::Project(action) => match action {
            ProjectAction::List(args) => {
                let projects = Project::list().context("Failed to get Project list")?;
                if args.list.json {
                    print_json(&projects)?;
                } else {
                    for project in projects {
                        println!("{:?}", project);
                    }
                }
            }
        },
    }

    Ok(())
}


