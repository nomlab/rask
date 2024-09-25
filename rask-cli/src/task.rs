use crate::client::Method;
use crate::project::Project;
use crate::user::User;
use crate::{Error, Result};
use crate::{IdNameSet, RASK_CLIENT};
use serde::{Deserialize, Serialize};

#[derive(Debug)]
pub struct Task;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TaskRequest {
    content: String,
    task_state_id: usize,
    assigner_id: usize,
    project_id: Option<usize>,
    due_at: Option<String>,
    description: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TaskResponse {
    pub id: usize,
    pub content: String,
    pub state: Option<TaskState>,
    pub description: Option<String>,
    pub deu_at: Option<String>,
    pub created_at: String,
    pub updated_at: String,
    pub creator: IdNameSet,
    pub assigner: IdNameSet,
    pub project: Option<IdNameSet>,
    pub url: String,
}

#[derive(Debug, Default, Serialize, Deserialize, Clone, Copy, PartialEq, clap::ValueEnum)]
pub enum TaskState {
    #[default]
    Todo = 1,
    Done = 2,
    Someday = 3,
}

impl Task {
    pub fn list() -> Result<Vec<TaskResponse>> {
        let client = RASK_CLIENT.get().ok_or(Error::NotInitialized)?;
        client
            .get("tasks.json")?
            .json()
            .map_err(|e| Error::JsonDecode(e.to_string()))
    }

    pub fn save(data: TaskRequest) -> Result<()> {
        let client = RASK_CLIENT.get().ok_or(Error::NotInitialized)?;
        let _ = client.send_request(Method::POST, "tasks.json", Some(data))?;
        Ok(())
    }
}

impl TaskRequest {
    pub fn new<S1, S2>(
        title: String,
        state: TaskState,
        assigner: S1,
        project: Option<S2>,
        due_at: Option<String>,
        description: Option<String>,
    ) -> Result<Self>
    where
        S1: AsRef<str>,
        S2: AsRef<str>,
    {
        let assigner_id = User::find_by_name(assigner)?.id;
        let project_id = match project {
            Some(p) => Some(Project::find_by_name(p)?.id),
            None => None,
        };
        Ok(Self {
            content: title,
            task_state_id: state as usize,
            assigner_id,
            project_id,
            due_at,
            description,
        })
    }
}
