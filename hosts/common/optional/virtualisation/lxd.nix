{ pkgs, ... }: {
  virtualisation = {
    lxd = {
      enable = true;
      zfsSupport = true;
      # recommendedSysctlSettings = true; # should be done in tweaks...
    };
  };
}
