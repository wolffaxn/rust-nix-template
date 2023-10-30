{
  description = "rust-nix-sample";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
  };

  outputs = { self, nixpkgs, flake-utils, naersk }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (system: let
      pkgs = (import nixpkgs) {
        inherit system;
      };
        
      packages.naersk = pkgs.callPackage naersk {};

    in rec {
      # for `nix build` & `nix run`
      defaultPackage = packages.naersk.buildPackage {
        src = ./.;
      };

      # for `nix develop`
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ cargo rustc ];
      };
    }
  );
}