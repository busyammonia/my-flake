{ config, ... }: {
  boot = {
    kernelParams = [
      "random.trust_cpu=off"
    ];
  };
}
