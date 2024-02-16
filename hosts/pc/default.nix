{ lib, pkgs, inputs, secrets, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  
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

  users.groups.keys = {};
  systemd.tmpfiles = {
    rules = [
      "d /persist/keys 0750 root keys -"
    ];
  };

  programs.adb.enable = true;

  programs.ssh = {
    startAgent = true;
    setXAuthLocation = true;
  };

  environment = {
    sessionVariables = {
      SSH_ASKPASS_REQUIRE="prefer";
    };
  };

  systemd.enableEmergencyMode = true;
  boot.initrd.systemd.emergencyAccess = true;
  boot.kernelParams = [ "rescue" "boot.shell_on_fail" "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  networking.firewall.enable = false;
  networking.hostName = lib.mkForce secrets."hostname";
  networking.hostId = lib.mkForce secrets."networking_hostid";
}
