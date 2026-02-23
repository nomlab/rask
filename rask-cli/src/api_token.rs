use crate::client::Method;
use crate::{Error, IdNameSet, Result, RASK_CLIENT};
use serde::{Deserialize, Serialize};

#[derive(Debug)]
pub struct ApiToken;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ApiTokenRequest {
    pub description: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ApiTokenResponse {
    pub id: usize,
    pub secret: String,
    pub description: String,
    pub expired_at: String,
    pub created_at: String,
    pub updated_at: String,
    user: IdNameSet,
    url: String,
}

impl ApiToken {
    pub fn save(data: ApiTokenRequest) -> Result<ApiTokenResponse> {
        let client = RASK_CLIENT.get().ok_or(Error::NotInitialized)?;
        let res = client.send_request(Method::POST, "api_tokens.json", Some(data))?;
        res.json().map_err(|e| Error::JsonDecode(e.to_string()))
    }

    pub fn list() -> Result<Vec<ApiTokenResponse>> {
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
