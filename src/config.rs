use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct Config {
    pub server_port: u16,
}

impl Config {
    pub fn from_env() -> Result<Self, config::ConfigError> {
        config::Config::builder()
            .add_source(config::File::with_name("config/default"))
            // APP_SERVER_PORT env var will override values in config/default
            .add_source(config::Environment::with_prefix("APP").separator("_"))
            .build()?
            .try_deserialize()
    }
}
