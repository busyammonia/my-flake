{ pkgs, config, ... }: {
  imports = [
    ./chromium
    ./firefox
    ./other
    ./tor-browser
  ];
}