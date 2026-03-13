use crate::{Error, Result};
use crate::{IdNameSet, RASK_CLIENT};
use serde::{Deserialize, Serialize};

#[derive(Debug)]
pub struct Project;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectResponse {
    pub id: usize,
    pub name: String,
    pub created_at: String,
    pub updated_at: String,
    pub user: IdNameSet,
    pub url: String,
}

impl Project {
    pub fn list() -> Result<Vec<ProjectResponse>> {
        let client = RASK_CLIENT.get().ok_or(Error::NotInitialized)?;
        client
            .get("projects.json")?
            .json()
            .map_err(|e| Error::JsonDecode(e.to_string()))
    }

    pub fn find_by_name<S: AsRef<str>>(name: S) -> Result<ProjectResponse> {
        let projects = Self::list()?;
        projects
            .into_iter()
            .find(|i| i.name == name.as_ref())
            .ok_or(Error::NotFound(
                name.as_ref().to_string(),
                "Project".to_string(),
            ))
    }
}
