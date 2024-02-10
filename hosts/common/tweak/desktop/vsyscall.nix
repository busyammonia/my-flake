{ config, ... }: {
  boot = {
    kernelParams = [
      "vsyscall=emulate"
    ];
  };
}
