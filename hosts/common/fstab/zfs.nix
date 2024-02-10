{ config, ... }: {

  boot = {
    initrd = {
      luks.devices."nixos" = {
        device = "/dev/disk/by-partlabel/disk-main-cryptroot";
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

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=100%" ];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/disk-main-efi";
      fsType = "vfat";
      neededForBoot = true;
    };

    "/nix" = {
      device = "zroot/nix";
      fsType = "zfs";
      options = [ "nodiratime" "noatime" "xattr" "posixacl" ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "zroot/persist";
      fsType = "zfs";
      options = [ "xattr" "posixacl" ];
      neededForBoot = true;
    };
  };
}
