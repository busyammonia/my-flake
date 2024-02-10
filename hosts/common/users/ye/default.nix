{ pkgs, inputs, config, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  users.mutableUsers = false;
  users.users.ye = {
    isNormalUser = true;

    extraGroups = [ "wheel" "video" "audio" ] ++ ifTheyExist [
      "minecraft"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "deluge"
      "networkmanager"
      "adbusers"
      "lxd"
      "vboxusers"
      "uucp"

      "cdrom"
      "tape"
      "input"
      "games"
      "floppy"
      "render"
      "realtime"
      "dialout"
      "network"
      "flashrom"
      "disk"
    ];

    initialPassword = "test";
    packages = [ pkgs.home-manager ];
  };

  fileSystems = {
    "/home/ye" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=100%" ];
    };
  };

  programs.fuse.userAllowOther = true;

  home-manager = {
    users = {
      ye = import ../../../../homes/ye/${config.networking.hostName}.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  systemd.tmpfiles = {
    rules = [
      "d /persist/home/ye/ 0750 ye ye -"
      "d /persist/home/ye/Downloads 0750 ye ye -"
      "d /persist/home/ye/Music 0750 ye ye -"
      "d /persist/home/ye/Pictures 0750 ye ye -"
      "d /persist/home/ye/Documents 0750 ye ye -"
      "d /persist/home/ye/Videos 0750 ye ye -"
      ''d "/persist/home/ye/VirtualBox VMs" 0750 ye ye -''
      "d /persist/home/ye/VM 0750 ye ye -"
      "d /persist/home/ye/Templates 0750 ye ye -"
      "d /persist/home/ye/Public 0750 ye ye -"
      "d /persist/home/ye/Desktop 0750 ye ye -"
      "d /persist/home/ye/NixConfig 0750 ye ye -"
      "d /persist/home/ye/.local 0750 ye ye -"
      "d /persist/home/ye/.config 0750 ye ye -"
      "d /persist/home/ye/.gnupg 0750 ye ye -"
      "d /persist/home/ye/.ssh 0750 ye ye -"
      "d /persist/home/ye/.nixops 0750 ye ye -"
      "d /persist/home/ye/.vscode 0750 ye ye -"
      "d /persist/home/ye/.vscode-insiders 0750 ye ye -"
      "d /persist/home/ye/.vscodium 0750 ye ye -"

      "d /persist/home/ye/.local/share 0750 ye ye -"
      "d /persist/home/ye/.local/share/keyrings 0750 ye ye -"
      "d /persist/home/ye/.local/share/direnv 0750 ye ye -"
      "d /persist/home/ye/.local/bin 0750 ye ye -"

      "d /persist/home/ye/.config 0750 ye ye -"
      ''d /persist/home/ye/.config/Code 0750 ye ye -''
      ''d /persist/home/ye/.config/"Code - Insiders" 0750 ye ye -''
      ''d /persist/home/ye/.config/VSCodium 0750 ye ye -''
    ];
  };
}
