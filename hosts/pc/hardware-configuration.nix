{ lib, inputs, outputs, pkgs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/profiles/all-hardware.nix"
    "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"

    ./fstab.nix
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

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr

      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    "VDPAU_DRIVER" = "radeonsi";
    "LIBVA_DRIVER_NAME" = "radeonsi";
  };

  hardware.cpu.intel.updateMicrocode = false;
  hardware.cpu.amd.updateMicrocode = false;


  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.05";
}
