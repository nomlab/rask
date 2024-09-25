use crate::{Error, Result};
use reqwest::blocking::Client;
pub use reqwest::blocking::Response;
pub use reqwest::Method;
use reqwest::Url;
use serde::Serialize;

#[derive(Debug, Clone)]
pub struct RawClient {
    url: Url,
    key: String,
}

impl RawClient {
    pub fn new<S1, S2>(url: S1, key: S2) -> Result<Self>
    where
        S1: AsRef<str>,
        S2: Into<String>,
    {
        let url = Url::parse(url.as_ref()).map_err(|e| Error::UrlParse(e.to_string()))?;
        Ok(Self {
            url,
            key: key.into(),
        })
    }

    pub fn get<S: AsRef<str>>(&self, path: S) -> Result<Response> {
        self.send_request(Method::GET, path, Option::<()>::None)
    }

    pub fn send_request<S, R>(&self, method: Method, path: S, body: Option<R>) -> Result<Response>
    where
        S: AsRef<str>,
        R: Serialize,
    {
        let res = Client::new()
            .request(
                method.clone(),
                self.url
                    .join(path.as_ref())
                    .map_err(|e| Error::UrlParse(e.to_string()))?,
            )
            .query(&[("api_token", &self.key)])
            .json(&body)
            .send()?;

        match res.status().as_u16() {
            200..=299 => Ok(res),
            _ => Err(Error::API(
                method.to_string(),
                res.status().to_string(),
                res.text().unwrap_or("Failed to show body".to_string()),
            )),
        }
    }
}
