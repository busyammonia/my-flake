{ pkgs, config, ... }: {
  imports = [
    ./browser
    ./p2p
  ];
}