{ disks, pcName, ... }:
let
  partlabelBioscompat = "${pcName}-BIOSCOMPAT";
  partlabelEfi = "${pcName}-EFI";
  labelEfi = "${builtins.substring 0 7 "${pcName}"}-EFI";
  partlabelCrypt = "${pcName}-crypt";
  labelCrypt = "${pcName}-zfs";
  labelZfsPool = "${pcName}-zroot";
in {
  disko.devices = {
    disk = {
      "${pcName}-main" = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          efiGptPartitionFirst = false;
          partitions = {
            compat = {
              priority = 1;
              type = "EF00";
              size = "32M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = null;
              };
              hybrid = {
                mbrPartitionType = "0x0c";
                mbrBootableFlag = false;
              };
            };
            ESP = {
              priority = 2;
              size = "512M";
              type = "EF00";
              name = partlabelEfi;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              type = "8300";
              name = partlabelCrypt;
              content = {
                type = "luks";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_write_workqueue"
                  "--perf-no_read_workqueue"
                ];
                name = labelCrypt;
                settings = { allowDiscards = true; };
                content = {
                  type = "zfs";
                  pool = labelZfsPool;
                };
              };
            };
          };
        };
      };
    };
    nodev = { "/" = { fsType = "tmpfs"; }; };
    zpool = {
      "${labelZfsPool}" = {
        type = "zpool";

        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "zstd-9";
          dnodesize = "auto";
          mountpoint = "none";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
          canmount = "on";
          checksum = "blake3";
          recordsize = "1M";
        };

        options = {
          ashift = "13";
          autotrim = "on";
          listsnapshots = "on";
        };

        mountpoint = "/";

        datasets = {
          reservation = {
            type = "zfs_fs";
            mountpoint = null;
            options = {
              canmount = "off";
              refreservation = "25G";
              primarycache = "none";
              secondarycache = "none";
              mountpoint = "none";
            };
          };

          nix = {
            type = "zfs_fs";
            mountOptions = [ "noatime" "nodiratime" ];
            mountpoint = "/nix";
            options = {
              acltype = "off";
              compression = "zstd-15";
              relatime = "off";
              atime = "off";
              checksum = "blake3";
              xattr = "off";
              secondarycache = "none";
              mountpoint = "/nix";
            };
          };

          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = { mountpoint = "/persist"; };
          };
        };
      };
    };
  };
}
