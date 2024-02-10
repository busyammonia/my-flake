{ config, ... }: {
  boot = {
    kernel = {
      sysctl = {
        "fs.protected_symlinks" = 1;
        "fs.protected_hardlinks" = 1;
        "fs.protected_fifos" = 2;
        "fs.protected_regular" = 2;
      };
    };
  };
}
