{ config, ... }: {
  boot = {
    kernelParams = [
      "iomem=relaxed"
    ];
  };
}
