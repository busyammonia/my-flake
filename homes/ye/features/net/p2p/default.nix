{ pkgs, config, ... }: {
  imports = [
    ./download
    ./torrent
  ];
}