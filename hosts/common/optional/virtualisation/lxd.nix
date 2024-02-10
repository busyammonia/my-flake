{ pkgs, ... }: {
  virtualisation = {
    lxd = {
      enable = true;
      # recommendedSysctlSettings = true; # should be done in tweaks...
    };
  };
}
