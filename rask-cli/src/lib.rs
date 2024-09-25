mod client;
pub mod project;
pub mod task;
pub mod user;

use client::RawClient;
use serde::{Deserialize, Serialize};
use std::sync::OnceLock;
use thiserror::Error;

static RASK_CLIENT: OnceLock<RawClient> = OnceLock::new();

#[derive(Debug)]
pub struct Rask;

impl Rask {
    pub fn init<S1, S2>(url: S1, key: S2)
    where
        S1: AsRef<str>,
        S2: Into<String>,
    {
        RASK_CLIENT.get_or_init(|| client::RawClient::new(url, key).unwrap());
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct IdNameSet {
    id: usize,
    name: String,
}

#[derive(Debug, Error)]
pub enum Error {
    #[error("Rask client not initialized")]
    NotInitialized,
    #[error(transparent)]
    Network(#[from] reqwest::Error),
    #[error("Failed to decode response json: {0}")]
    JsonDecode(String),
    #[error("Not found: \"{0}\" from \"{1}\"")]
    NotFound(String, String),
    #[error("Failed to Parse URL: {0}")]
    UrlParse(String),
    #[error("Failed to {0} data, satus: {1}, body: {2}")]
    API(String, String, String),
}

type Result<T> = std::result::Result<T, Error>;
