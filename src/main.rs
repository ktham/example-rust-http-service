use axum::{response::IntoResponse, routing::get, Router};
use std::net::SocketAddr;

mod config;
use config::Config;

#[tokio::main]
async fn main() {
    let cfg = Config::from_env().expect("Failed to load config");

    let addr = SocketAddr::from(([0, 0, 0, 0], cfg.server_port));

    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    println!("listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app()).await.unwrap();
}

fn app() -> Router {
    Router::new().route("/ping", get(ping))
}

async fn ping() -> impl IntoResponse {
    "pong!"
}

#[cfg(test)]
mod tests {
    use super::*;
    use axum::{
        body::Body,
        http::{Request, StatusCode},
    };
    use http_body_util::BodyExt; // for `collect`
    use tower::ServiceExt; // for `call`, `oneshot`, and `ready`

    #[tokio::test]
    async fn ping() {
        let app = app();

        let response = app
            .oneshot(Request::builder().uri("/ping").body(Body::empty()).unwrap())
            .await
            .unwrap();

        assert_eq!(response.status(), StatusCode::OK);

        let body = response.into_body().collect().await.unwrap().to_bytes();
        assert_eq!(&body[..], b"pong!");
    }
}
