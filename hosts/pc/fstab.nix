{ inputs, outputs, config, pkgs, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  programs.fuse.userAllowOther = true;

  environment.persistence."/nix/persist" = {
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
    supportedFilesystems = [ "f2fs" "vfat" ];
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

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=100%" ];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/disk-pc-main-ESP";
      fsType = "vfat";
      neededForBoot = true;
    };

    "/nix" = {
      device = "/dev/disk/by-partlabel/disk-pc-main-root";
      fsType = "f2fs";
      options = [
        "defaults"
        "X-mount.mkdir"
        "compress_algorithm=zstd:9"
        "compress_chksum"
        "atgc"
        "gc_merge"
        "lazytime"
        "checkpoint_merge"
        "inlinecrypt"
        "compress_cache"
        "age_extent_cache"
        "flush_merge"
        "background_gc=on"
        "discard"
        "no_heap"
        "user_xattr"
        "inline_xattr"
        "acl"
        "inline_data"
        "inline_dentry"
      ];
      neededForBoot = true;
    };
  };
}
