{ inputs, outputs, config, pkgs, secrets, hostname, displayForBoot, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  programs.fuse.userAllowOther = true;

  environment = {
    persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/waydroid"
        "/var/lib/libvirt"
        "/var/lib/chrony"
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
      files = [ "/etc/adjtime" ];
    };
    "etc" = { "machine-id" = { text = secrets."machine_id"; }; };
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
      systemd.enable = true;
      supportedFilesystems = [
        "zfs"
        "vfat"
        "exfat"
        "f2fs"
        "ext2"
        "ext3"
        "ext4"
        "xfs"
        "ntfs"
        "btrfs"
        "fat32"
        "fat16"
        "fat8"
      ];
    };
    loader = let
      bootWidth = displayForBoot.resolution.width;
      bootHeight = displayForBoot.resolution.height;
      gfxmode =
        "${builtins.toString bootWidth}x${builtins.toString bootHeight}";
    in {
      grub = {
        gfxpayloadEfi = "keep";
        gfxpayloadBios = "keep";
        gfxmodeEfi = gfxmode;
        gfxmodeBios = gfxmode;
        enable = true;
        efiSupport = true;
        #device = "/dev/vda";
        mirroredBoots = [
          {
            devices = [ "nodev" ];
            path = "/boot";
          }
          #{
          #  devices = [ "/dev/vda" ];
          #  path = "/boot";
          #}
        ];
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
        efiInstallAsRemovable = true;
      };
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
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
