{ target, ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = target;
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              type = "8300";
              name = "cryptdata";
              content = {
                type = "luks";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_write_workqueue"
                  "--perf-no_read_workqueue"
                ];
                name = "data";
                settings = { allowDiscards = true; };
                content = {
                  type = "zfs";
                  pool = "zdata";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      zdata = {
        type = "zpool";

        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          relatime = "on";
          compression = "zstd";
          dnodesize = "auto";
          mountpoint = "none";
          normalization = "formD";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
          canmount = "on";
          checksum = "blake3";
        };

        options = {
          ashift = "13";
          autotrim = "off";
          listsnapshots = "on";
        };

        mountpoint = "/mnt";

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

          persist = {
            type = "zfs_fs";
            mountpoint = "/zdata";
            options = { mountpoint = "/zdata"; };
          };
        };
      };
    };
  };
}
