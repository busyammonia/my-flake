{ pkgs, ... }: {
  networking = {
    useDHCP = false;
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-l2tp
        networkmanager_strongswan
      ];
    };
  };
}
