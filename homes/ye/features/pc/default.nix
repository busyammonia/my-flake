{ pkgs, config, ... }: {
  imports = [
    ./cli
    ./gui
  ];
}