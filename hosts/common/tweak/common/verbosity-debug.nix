{ config, ... }: {
  boot = {
    kernelParams =
      [ "boot.trace" "udev.log_level=7" "debug" "rd.udev.log_level=7" "systemd.log_level=debug" "rd.systemd.show_status=true" ];
    consoleLogLevel = 7;
    initrd.verbose = true;
  };
}
