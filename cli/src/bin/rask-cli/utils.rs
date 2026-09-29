use anyhow::{anyhow, Context, Result};
use rask::task::TaskResponse;
use rask::user::*;

pub fn user_name_to_id(users: Vec<UserResponse>, name: &str) -> Option<usize> {
    for user in users {
        if user.screen_name == name {
            return Some(user.id);
        }
    }
    None
}

pub fn filter_tasks_by_user(tasks: Vec<TaskResponse>, target_user: &str) -> Result<Vec<TaskResponse>> {
    let users = User::list().context("Failed to get User list")?;
    let user_id = user_name_to_id(users, target_user)
        .ok_or_else(|| anyhow!("User not found"))?;

    Ok(tasks
        .into_iter()
        .filter(|task| task.assigner.id == user_id)
        .collect())
}

