{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [];
        pkgs = import nixpkgs { inherit system overlays; };
      in {
        devShells.default = pkgs.mkShell {
          NIX_CONFIG =
            "extra-experimental-features = nix-command flakes repl-flake";
          nativeBuildInputs = with pkgs; [
            nix
            home-manager
            git
            git-crypt
            transcrypt
            git-secret
            agebox

            sops
            ssh-to-age
            gnupg
            age
            passphrase2pgp
          ];
        };
      });
}
