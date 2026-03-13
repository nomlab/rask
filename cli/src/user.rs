use crate::RASK_CLIENT;
use crate::{Error, Result};
use serde::{Deserialize, Serialize};

#[derive(Debug)]
pub struct User;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UserResponse {
    pub id: usize,
    pub name: String,
    pub created_at: String,
    pub updated_at: String,
    pub url: String,
}

impl User {
    pub fn list() -> Result<Vec<UserResponse>> {
        let client = RASK_CLIENT.get().ok_or(Error::NotInitialized)?;
        client
            .get("users.json")?
            .json()
            .map_err(|e| Error::JsonDecode(e.to_string()))
    }

    pub fn find_by_name<S: AsRef<str>>(name: S) -> Result<UserResponse> {
        let users = Self::list()?;
        users
            .into_iter()
            .find(|i| i.name == name.as_ref())
            .ok_or(Error::NotFound(
                name.as_ref().to_string(),
                "User".to_string(),
            ))
    }
}
