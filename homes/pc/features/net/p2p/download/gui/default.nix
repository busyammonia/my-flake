{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    persepolis
    media-downloader
  ];
}
