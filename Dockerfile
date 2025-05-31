################################################################################
### Build Image
################################################################################
FROM rust:1-slim-bookworm as build-image

WORKDIR /example-rust-http-service

# Copy build config
COPY rust-toolchain.toml ./
RUN rustup show
COPY Cargo.lock /example-rust-http-service/Cargo.lock
COPY Cargo.toml /example-rust-http-service/Cargo.toml

# Copy source
COPY src /example-rust-http-service/src

# Build artifact
RUN --mount=type=cache,target=/build/target \
    --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    set -eux; \
    cargo build --release

################################################################################
### Final Image
################################################################################
FROM debian:bookworm-slim

# Create a non-root user
RUN useradd -m -u 1000 appuser

WORKDIR /home/appuser

COPY --from=build-image /example-rust-http-service/target/release/example-rust-http-service /home/appuser/example-rust-http-service

COPY config /home/appuser/config

USER appuser

EXPOSE 8080

ENTRYPOINT ["/home/appuser/example-rust-http-service"]
