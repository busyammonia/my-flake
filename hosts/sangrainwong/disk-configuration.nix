{ inputs, outputs, config, pkgs, secrets, hostname, ... }: {
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
        device = "/dev/disk/by-partlabel/disk-${hostname}-main-crypt";
        allowDiscards = true;
      };
      luks.devices."pc-hdd-zfs" = {
        device = "/dev/disk/by-partlabel/disk-${hostname}-hdd-crypt";
        allowDiscards = true;
      };
    };
    supportedFilesystems = [ "zfs" ];
    loader = {
      grub = {
        gfxpayloadEfi = "keep";
        gfxpayloadBios = "keep";
        gfxmodeEfi = "${secrets.resolution.width}x${secrets.resolution.height}";
        gfxmodeBios = "${secrets.resolution.width}x${secrets.resolution.height}";
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
      device = "/dev/disk/by-partlabel/disk-${hostname}-main-ESP";
      fsType = "vfat";
      neededForBoot = true;
    };

    "/nix" = {
      device = "${hostname}-zroot/nix";
      fsType = "zfs";
      options = [ "nodiratime" "noatime" "norelatime" "noxattr" ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "${hostname}-zroot/persist";
      fsType = "zfs";
      options = [ "relatime" "nodiratime" "noatime" "xattr" "posixacl" ];
      neededForBoot = true;
    };

    "/zhome" = {
      device = "${hostname}-zroot/zhome";
      fsType = "zfs";
      options = [ "relatime" "xattr" "posixacl" ];
      neededForBoot = true;
    };

    "/mnt/hdd" = {
      device = "${hostname}-zdata/default";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/mnt/hdd/share" = {
      device = "${hostname}-zdata/share";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
