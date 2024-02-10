{ config, ... }: {
  boot = { kernelParams = [ "preempt=full" ]; };
}
