{ pkgs, config, ... }: {
  home.packages = with pkgs;
    [
      bitwarden
      pass-wayland
    ];
}
