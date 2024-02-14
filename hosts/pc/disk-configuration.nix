{ inputs, outputs, config, pkgs, ... }: let pcName = "pc"; in {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  programs.fuse.userAllowOther = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/waydroid"
      "/var/lib/libvirt"
      "/etc/libvirt"
      "/etc/NetworkManager/system-connections"
      "/var/cache/smartdns"
      "/srv"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/etc/nix/id_rsa";
        parentDirectory = { mode = "u=rwx,g=,o="; };
      }
    ];
  };

  boot = {
    initrd = {
      luks.devices."pc-zfs" = {
        device = "/dev/disk/by-partlabel/disk-${pcName}-main-crypt";
        allowDiscards = true;
      };
      luks.devices."pc-hdd-zfs" = {
        device = "/dev/disk/by-partlabel/disk-${pcName}-hdd-crypt";
        allowDiscards = true;
      };
    };
    supportedFilesystems = [ "zfs" ];
    loader = {
      grub = {
        gfxpayloadEfi = "keep";
        gfxpayloadBios = "keep";
        gfxmodeEfi = "2560x1440";
        gfxmodeBios = "2560x1440";
        enable = true;
        efiSupport = true;
        device = "nodev";
        copyKernels = true;
        zfsSupport = true;
        memtest86 = {
          enable = true;
          params = [ "btrace" ];
        };
        enableCryptodisk = true;
        useOSProber = true;
        extraEntries = ''
          menuentry "Firmware setup" {
            fwsetup
          }
          menuentry "Reboot" {
            reboot
          }
          menuentry "Shutdown" {
            halt
          }
        '';
      };
      efi.efiSysMountPoint = "/boot";
      efi.canTouchEfiVariables = true;
    };
  };

  services.zfs = {
    trim = { enable = true; };
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
  };

  boot.zfs = {
    enableUnstable = true;
    removeLinuxDRM = true;
    allowHibernation = false; # Conflicts with force import
    forceImportRoot = true;
    forceImportAll = true;
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=100%" ];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/disk-${pcName}-main-ESP";
      fsType = "vfat";
      neededForBoot = true;
    };

    "/nix" = {
      device = "${pcName}-zroot/nix";
      fsType = "zfs";
      options = [ "nodiratime" "noatime" "norelatime" "noxattr" ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "${pcName}-zroot/persist";
      fsType = "zfs";
      options = [ "relatime" "nodiratime" "noatime" "xattr" "posixacl" ];
      neededForBoot = true;
    };

    "/zhome" = {
      device = "${pcName}-zroot/zhome";
      fsType = "zfs";
      options = [ "relatime" "xattr" "posixacl" ];
      neededForBoot = true;
    };

    "/zdata/Downloads" = {
      device = "${pcName}-zdata/downloads";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/zdata/Other" = {
      device = "${pcName}-zdata/other";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/zdata/Share" = {
      device = "${pcName}-zdata/share";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/zdata/Torrents" = {
      device = "${pcName}-zdata/torrents";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/zdata/Trash" = {
      device = "${pcName}-zdata/trash";
      fsType = "zfs";
      options = [ "nodiratime" "noatime" "norelatime" "noxattr" ];
      neededForBoot = true;
    };

    "/zdata/VM" = {
      device = "${pcName}-zdata/vm";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
