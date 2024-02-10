{ config, ... }: {
  boot = {
    kernelParams = [
      "split_lock_detect=off"
    ];
  };
}
