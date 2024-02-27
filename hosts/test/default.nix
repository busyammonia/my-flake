{ lib, pkgs, inputs, secrets, username, hostname, configName, homeDirectory, ...
}: {
  imports = [
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];
  users = {
    mutableUsers = true;
    users = { root = { password = "test"; }; };
  };
}
