{ pkgs, ... }: {
  imports = [ ./smartdns ];

  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    networkmanager.dns = "none";
  };

  services.resolved.enable = false;
}
