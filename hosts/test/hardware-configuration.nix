{ lib, inputs, outputs, pkgs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"

    ./disk-configuration.nix
  ];
  boot = {
    initrd = {
      availableKernelModules = [
        "aesni_intel"
        "cryptd"
        "uas"
        "usbcore"
        "usb_storage"
        "vfat"
        "nls_cp437"
        "nls_iso8859_1"
        "amdgpu"
        "kvm-intel"
        "kvm-amd"
        "msr"
        "i2c-dev"
        "netconsole"
        "coretemp"
        "nct6775"
        "e1000e"
      ];
    };
  };

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr

      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.cpu.intel.updateMicrocode = false;
  hardware.cpu.amd.updateMicrocode = false;


  hardware.enableAllFirmware = false;
  hardware.enableRedistributableFirmware = false;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.hostId = "66666666";
  system.stateVersion = "24.05";
}
