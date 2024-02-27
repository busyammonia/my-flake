{ disks, hostname, ... }:
let
  addSuffix = (maxLength: sep: suffix: str:
    builtins.substring 0 maxLength (builtins.substring 0
      (maxLength - builtins.stringLength sep - builtins.stringLength suffix) str
      + sep + suffix));
  zfsPoolName = (sep: suffix: str: str + sep + suffix);
  signBios = "BIOS";
  signESP = "ESP";
  signCrypt = "crypt";
  signZfs = "zfs";
  labelBioscompat = addSuffix 11 "-" signBios;
  labelEfi = addSuffix 11 "-" signESP;
  labelCrypt = addSuffix 64 "-" signZfs;
  labelZfsPool = zfsPoolName "-";
  hddName = "hdd";
  hddNameWithPc = "${hostname}-${hddName}";
  main = {
    partlabelBioscompat = signBios;
    partlabelEfi = signESP;
    partlabelCrypt = signCrypt;
    labelBioscompat = labelBioscompat hostname;
    labelEfi = labelEfi hostname;
    labelCrypt = labelCrypt hostname;
    labelZfsPool = labelZfsPool "zroot" hostname;
  };
  hdd = let name = hddNameWithPc;
  in {
    partlabelBioscompat = signBios;
    partlabelEfi = signESP;
    partlabelCrypt = signCrypt;
    labelBioscompat = labelBioscompat name;
    labelEfi = labelEfi name;
    labelCrypt = labelCrypt name;
    labelZfsPool = labelZfsPool "zdata" hostname;
  };
in {
  disko.devices = {
    disk = {
      "${hostname}-main" = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          efiGptPartitionFirst = false;
          partitions = {
            TOW-BOOT-FI = {
              priority = 1;
              type = "EF00";
              start = "32M";
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
              name = main.partlabelEfi;
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-n ${main.labelEfi}" ];
                mountpoint = "/boot/efi";
              };
            };
            root = {
              priority = 3;
              size = "100%";
              type = "8300";
              name = main.partlabelCrypt;
              content = {
                type = "luks";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_write_workqueue"
                  "--perf-no_read_workqueue"
                ];
                name = main.labelCrypt;
                settings = { allowDiscards = true; };
                content = {
                  type = "zfs";
                  pool = main.labelZfsPool;
                };
              };
            };
          };
        };
      };
      "${hddNameWithPc}" = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          efiGptPartitionFirst = false;
          partitions = {
            mbr-gap = {
              priority = 1;
              type = "EF02";
              size = "8M";
              name = "mbr-gap";
              hybrid = {
                mbrPartitionType = "0x0";
                mbrBootableFlag = true;
              };
            };
            ESP = {
              priority = 2;
              size = "512M";
              type = "EF00";
              name = hdd.partlabelEfi;
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-n ${hdd.labelEfi}" ];
                mountpoint = "/boot_hdd";
              };
            };
            root = {
              size = "100%";
              type = "8300";
              name = hdd.partlabelCrypt;
              content = {
                type = "luks";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_write_workqueue"
                  "--perf-no_read_workqueue"
                ];
                name = hdd.labelCrypt;
                settings = { allowDiscards = true; };
                content = {
                  type = "zfs";
                  pool = hdd.labelZfsPool;
                };
              };
            };
          };
        };
      };
    };
    nodev = { "/" = { fsType = "tmpfs"; }; };
    zpool = {
      "${main.labelZfsPool}" = {
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
          ashift = "12";
          autotrim = "off";
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
              sync = "disabled";
              acltype = "off";
              compression = "zstd-9";
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
            options = {
              compression = "zstd-9";
              mountpoint = "/persist";
            };
          };

          zhome = {
            type = "zfs_fs";
            mountpoint = "/zhome";
            options = { mountpoint = "/zhome"; };
          };
        };
      };
      "${hdd.labelZfsPool}" = {
        type = "zpool";

        rootFsOptions = {
          sync = "disabled";
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
          ashift = "12";
          autotrim = "off";
          listsnapshots = "on";
        };

        mountpoint = "/mnt/hdd";

        datasets = {
          reservation = {
            type = "zfs_fs";
            mountpoint = null;
            options = {
              canmount = "off";
              refreservation = "100G";
              primarycache = "none";
              secondarycache = "none";
              mountpoint = "none";
            };
          };

          share = {
            type = "zfs_fs";
            mountpoint = "/share";
            options = { mountpoint = "/share"; };
          };

          default = {
            type = "zfs_fs";
            mountpoint = "/";
            options = { mountpoint = "/"; };
          };
        };
      };
    };
  };
}
