{ disks, ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          efiGptPartitionFirst = false;
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "f2fs";
                extraArgs = ["-O extra_attr,inode_checksum,sb_checksum,compression"];
                mountOptions = ["defaults" "compress_algorithm=zstd:9" "compress_chksum" "atgc" "gc_merge" "lazytime" "checkpoint_merge"];
                mountpoint = "/nix";
              };
            };            
          };
        };
      };
    };
  };
}
