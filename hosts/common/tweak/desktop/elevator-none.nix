{ config, ... }: {
  boot = {
    kernelParams = [
      "elevator=none"
    ];
  };
}
