{ pkgs, ... }: {
  virtualisation = {
    lxc = {
      enable = true;
      lxcfs = { enable = true; };
    };
  };
}
