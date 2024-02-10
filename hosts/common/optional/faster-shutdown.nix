{ pkgs, ... }: {
  systemd = {
    # Reduce default service stop timeouts for faster shutdown
    extraConfig = ''
      DefaultTimeoutStopSec=15s
      DefaultTimeoutAbortSec=5s
    '';
  };
}
