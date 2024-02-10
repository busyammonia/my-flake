{ config, ... }: {
  boot = {
    kernel = { sysctl = { "kernel.sysrq" = 1; }; };
    kernelParams = [ "sysrq_always_enabled=1" ];
  };
}
