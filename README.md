# example-rust-http-service
This is an example implementation of a basic Rust HTTP service using:

* [Axum](https://github.com/tokio-rs/axum)
* Multi-Stage Container Build

## Getting Started

### Requirements
- [Rust Toolchain (rustc/cargo)](https://www.rust-lang.org/tools/install) >= 1.86.0
  * Use Nix development shell provided by `flake.nix` which includes .
  * Or download [rustup](https://www.rust-lang.org/tools/install)
    - On MacOS `brew install rustup`
- [podman](https://podman.io/) >= 5.25
  * On MacOS: Install through Podman Desktop installer from https://podman.io/
  * On Ubuntu: `apt-get install -y podman`
- [podman-compose](https://docs.podman.io/en/stable/markdown/podman-compose.1.html) >= 1.2.0
  * On MacOS: `brew install podman-compose`
  * On Ubuntu: `apt-get install -y python3-pip` then `pip3 install podman-compose`

### Running Tests
```
cargo test --all
```

### Starting The Server

#### Using Cargo
This is the quickest way to start the server.

```
cargo run -p example-rust-http-service
```

#### From The Executable Binary
This builds an executable binary.

This is how we would start the server in a production and containerized environment.

```
# This will generate the executable binary
cargo build --release

# This will start the server
./target/release/example-rust-http-service
```

#### From within a container
This builds a container image that contains the executable binary of our server.

```
podman compose up
```

To rebuild the image:
```
podman compose build
```

### Confirming Server Behavior
A server process should be bound on port 8080 and should respond to GET /ping.

```
❯ curl localhost:8080/ping
pong!
```

# License
The MIT license.

Copyright (c) 2025 Kevin Tham

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
