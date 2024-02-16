{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    amdgpu_top
    vdpauinfo
    libva-utils
    vulkan-tools
    radeontop
    glxinfo
    lsof
    lshw
    hw-probe
    dmidecode
    edid-decode
    edid-generator
    libdisplay-info
    rwedid
    read-edid
    i2c-tools
    lm_sensors
    dippi
    pciutils
    usbutils
    hdparm
  ];
}
