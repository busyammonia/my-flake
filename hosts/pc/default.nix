{ lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/ye

    ../common/tweak/common
    ../common/tweak/desktop

    ../common/optional/sound.nix
    ../common/optional/network-manager.nix
    ../common/optional/zram.nix
    ../common/optional/all-fs.nix
    ../common/optional/virtualisation
    ../common/optional/ananicy.nix
    ../common/optional/dns
    ../common/optional/auto-cpufreq.nix
    ../common/optional/thermald.nix
    ../common/optional/time
    ../common/optional/oomd.nix
    ../common/optional/cgroups.nix
    ../common/optional/faster-shutdown.nix
    ../common/optional/plymouth.nix
    ../common/optional/uresourced.nix
    ../common/optional/prelockd.nix
    ../common/optional/memavaild.nix
  ];

  # temporary
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  security.pam.services.login.enableKwallet = true;

  programs.adb.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  networking.firewall.enable = false;
  networking.hostName = "pc";
  networking.hostId = lib.mkDefault "8425e349";
}
