{ config, ... }: {
  boot = {
    kernelParams =
      [ "rd.systemd.show_status=true" ];
    consoleLogLevel = 3;
    initrd.verbose = true;
  };
}
