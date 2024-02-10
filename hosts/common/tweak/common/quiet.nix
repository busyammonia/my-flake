{ config, ... }: {
  boot = {
    kernelParams =
      [ "udev.log_level=3" "quiet" "rd.systemd.show_status=false" ];
    consoleLogLevel = 0;
  };
}
