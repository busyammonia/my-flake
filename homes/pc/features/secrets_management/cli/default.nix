{ pkgs, config, ... }: {
  home.packages = with pkgs;
    [
      bitwarden-cli
      bitwarden-menu
      passwdqc
    ];
}
