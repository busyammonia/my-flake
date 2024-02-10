{ config, ... }: {
  boot = { kernelParams = [ "amd_pstate=active" "intel_pstate=active" ]; };
}
