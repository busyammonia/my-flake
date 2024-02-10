{ config, ... }: {
  boot = {
    kernel = {
      sysctl = {
        "vm.dirty_ratio" = 3;
        "vm.dirty_background_ratio" = 3;
        "vm.dirty_expire_centisecs" = 3000;
        "vm.dirty_writeback_centisecs" = 1500;
        "vm.min_free_kbytes" = 59030;
      };
    };
  };
}
