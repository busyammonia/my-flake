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
      "ye"
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

  users.groups.ye = {};

  systemd.tmpfiles = {
    rules = [
      "d /zhome/ye/ 0750 ye ye -"
      "d /zhome/ye/Downloads 0750 ye ye -"
      "d /zhome/ye/Music 0750 ye ye -"
      "d /zhome/ye/Pictures 0750 ye ye -"
      "d /zhome/ye/Documents 0750 ye ye -"
      "d /zhome/ye/Videos 0750 ye ye -"
      ''d "/zhome/ye/VirtualBox VMs" 0750 ye ye -''
      "d /zhome/ye/VM 0750 ye ye -"
      "d /zhome/ye/Templates 0750 ye ye -"
      "d /zhome/ye/Public 0750 ye ye -"
      "d /zhome/ye/Desktop 0750 ye ye -"
      "d /zhome/ye/NixConfig 0750 ye ye -"
      "d /zhome/ye/.local 0750 ye ye -"
      "d /zhome/ye/.config 0750 ye ye -"
      "d /zhome/ye/.gnupg 0750 ye ye -"
      "d /zhome/ye/.ssh 0750 ye ye -"
      "d /zhome/ye/.nixops 0750 ye ye -"
      "d /zhome/ye/.vscode 0750 ye ye -"
      "d /zhome/ye/.vscode-insiders 0750 ye ye -"
      "d /zhome/ye/.vscodium 0750 ye ye -"

      "d /zhome/ye/.local/share 0750 ye ye -"
      "d /zhome/ye/.local/share/keyrings 0750 ye ye -"
      "d /zhome/ye/.local/share/direnv 0750 ye ye -"
      "d /zhome/ye/.local/bin 0750 ye ye -"

      "d /zhome/ye/.config 0750 ye ye -"
      ''d /zhome/ye/.config/Code 0750 ye ye -''
      ''d /zhome/ye/.config/"Code - Insiders" 0750 ye ye -''
      ''d /zhome/ye/.config/VSCodium 0750 ye ye -''
    ];
  };
}
