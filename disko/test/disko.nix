{ target, ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = target;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
              name = "bioscompat";
            };
            ESP = {
              size = "512M";
              type = "EF00";
              name = "efi";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            nixos = {
              size = "100%";
              type = "8300";
              name = "cryptroot";
              content = {
                type = "luks";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_write_workqueue"
                  "--perf-no_read_workqueue"
                ];
                name = "nixos";
                settings = { allowDiscards = true; };
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
    };
    nodev = { "/" = { fsType = "tmpfs"; }; };
    zpool = {
      zroot = {
        type = "zpool";

        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "zstd";
          dnodesize = "auto";
          mountpoint = "none";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
          canmount = "on";
          checksum = "blake3";
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
              refreservation = "35G";
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
              relatime = "off";
              atime = "off";
              secondarycache = "none";
              "com.sun:auto-snapshot" = "false";
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
