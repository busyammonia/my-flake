{ pkgs, ... }: {
  imports = [
    ./libvirtd-qemu.nix
    ./lxc.nix
    ./docker.nix
    ./lxd.nix
    ./waydroid.nix
  ];
}
