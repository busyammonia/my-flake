{ config, ... }: {

  boot = {
    initrd = {
      luks.devices."data" = {
        device = "/dev/disk/by-partlabel/disk-main-cryptdata";
        allowDiscards = true;
      };
    };

    supportedFilesystems = [ "zfs" ];
  };

  fileSystems = {
    "/mnt/zdata" = {
      device = "zdata/persist";
      fsType = "zfs";
      options = [ "xattr" "posixacl" ];
      neededForBoot = true;
    };
  };
}
