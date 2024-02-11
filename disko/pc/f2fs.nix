{ disks, ... }: let pcName = "pc"; in {
  disko.devices = {
    disk = {
      "${pcName}-main" = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          efiGptPartitionFirst = false;
          partitions = {
            boot = {
              priority = 1;
              size = "1M";
              type = "EF02"; # for grub MBR
              name = "bioscompat";
            };
            ESP = {
              priority = 2;
              size = "512M";
              type = "EF00";
              name = "ESP";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              name = "root";
              content = {
                type = "filesystem";
                format = "f2fs";
                extraArgs = [
                  "-O extra_attr,inode_checksum,sb_checksum,compression,encrypt"
                  "-l ${pcName}-root"
                ];
                mountOptions = [
                  "defaults"
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
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };
  };
}
