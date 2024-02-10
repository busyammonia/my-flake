{ config, ... }: {
  boot = {
    extraModprobeConfig = ''
      options kvm-amd nested=1
      options kvm-intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
  };
}
