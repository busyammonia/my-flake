{ pkgs, config, ... }: {
  home.packages = with pkgs;
    [
      opera
      palemoon-bin
      microsoft-edge
      google-chrome
    ];
}
