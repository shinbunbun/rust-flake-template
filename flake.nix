{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        lib = nixpkgs.lib;
        projectNameText = builtins.readFile ./project_name;
        lines = builtins.split "\n" projectNameText;
        projectName = builtins.head lines;
        hashMap = {
          "x86_64-linux" = "sha256-HCc0Z/glQCU6gpy1T8FDDBsIvSwkFe+S0Xgp1S7bEAA=";
          "x86_64-darwin" = "sha256-HCc0Z/glQCU6gpy1T8FDDBsIvSwkFe+S0Xgp1S7bEAA=";
          "aarch64-linux" = "sha256-NGwQzPACCMyKxlAUYXgvN2eX8r6jwHNt4o6JHvNgyZg=";
          "aarch64-darwin" = "sha256-NGwQzPACCMyKxlAUYXgvN2eX8r6jwHNt4o6JHvNgyZg=";
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            rust-overlay.overlays.default
          ];
          config.allowUnfree = true;
        };
        pkgsForDocker = import nixpkgs {
          inherit system;
          crossTarget = if lib.strings.hasSuffix "-darwin" system
          then lib.strings.replaceSuffix "-darwin" "-linux" system
          else system;
          overlays = [
            rust-overlay.overlays.default
          ];
          config.allowUnfree = true;
          config.allowUnsupportedSystem = true;
        };
        dockerImage = pkgsForDocker.dockerTools.buildImage {
          name = projectName;
          tag = "latest";
          fromImage = pkgsForDocker.dockerTools.pullImage {
            # nix-prefetch-docker --image-name debian --image-tag bullseye-slim --arch amd64
            imageName = "debian";
            imageDigest = "sha256:7aafeb23eaef5d5b1de26e967b9a78f018baaac81dd75246b99781eaaa2d59ef";
            hash = hashMap.${system};
            finalImageName = "debian";
            finalImageTag = "bullseye-slim";
          };

          copyToRoot = pkgsForDocker.buildEnv {
            name = "docker-env";
            paths = [
              # Dockerで使うRustのバージョンはここで指定する
              (pkgsForDocker.rust-bin.stable."1.86.0".default.override {
                extensions = [
                  "rust-src"
                  "rustc"
                  "cargo"
                  "rustfmt"
                  "clippy"
                ];
              })
              pkgs.gcc
            ];
          };

          config = {
            Cmd = [ "bash" ];
          };
        };
      in
      {
        defaultPackage = dockerImage;
        devShell = pkgs.mkShell {
          name = projectName;
          buildInputs = [
            pkgs.rustup
          ];
          packages = [
            # devShellで使うRustのバージョンはここで指定する
            (pkgs.rust-bin.stable."1.86.0".default.override {
              extensions = [
                "rust-src"
                "rustc"
                "cargo"
                "rustfmt"
                "clippy"
              ];
            })
          ];
        };
        dockerImage = dockerImage;
      }
    );
}
