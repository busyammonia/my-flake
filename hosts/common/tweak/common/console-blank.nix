{ config, ... }: {
  boot = {
    kernelParams = [
      "consoleblank=0"
    ];
  };
}
