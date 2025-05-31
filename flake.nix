{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        rustToolchainOverlay = final: prev: {
          rustToolchain = final.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            rust-overlay.overlays.default
            rustToolchainOverlay
          ];
        };
      in
      {
        # The packages available in the development shell created by running `nix develop`
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            rustToolchain
            openssl
            pkg-config
            cargo-deny
            cargo-edit
            cargo-watch
            rust-analyzer
          ];

          env = {
            # Required by rust-analyzer
            RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
          };
        };
      }
    );
}
