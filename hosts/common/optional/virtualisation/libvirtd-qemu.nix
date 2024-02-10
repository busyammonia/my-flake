{ pkgs, ... }: {
  virtualisation = {
    kvmgt = { enable = true; };
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        swtpm = { enable = true; };
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull ];
        };
      };
    };
    spiceUSBRedirection = { enable = true; };
  };

  boot.kernelModules = [ "kvm-amd" "kvm-intel" "vfio-pci" ];

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    # QEMU/KVM, provides:
    #   qemu-storage-daemon qemu-edid qemu-ga
    #   qemu-pr-helper qemu-nbd elf2dmp qemu-img qemu-io
    #   qemu-kvm qemu-system-x86_64 qemu-system-aarch64 qemu-system-i386
    qemu_kvm

    # Install all packages about QEMU, provides:
    #   ......
    #   qemu-loongarch64 qemu-system-loongarch64
    #   qemu-riscv64 qemu-system-riscv64 qemu-riscv32  qemu-system-riscv32
    #   qemu-system-arm qemu-arm qemu-armeb qemu-system-aarch64 qemu-aarch64 qemu-aarch64_be
    #   qemu-system-xtensa qemu-xtensa qemu-system-xtensaeb qemu-xtensaeb
    #   ......
    # qemu_full
  ];
}
