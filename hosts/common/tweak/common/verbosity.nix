{ config, ... }: {
  boot = {
    kernelParams =
      [ "udev.log_level=7" "rd.udev.log_level=7" "rd.systemd.show_status=true" ];
    consoleLogLevel = 7;
    initrd.verbose = true;
  };
}
