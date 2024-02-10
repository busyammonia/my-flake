{ pkgs, config, ... }: {
  services = {
    chrony = let
      # A set of servers that support NTS, preventing MITM attacks.
      ntsServers = [
        # Cloudflare's NTP server.
        "time.cloudflare.com"

        # The netnod NTP server.
        "nts.netnod.se"

        # The NTPsec servers.
        # FIXME: These may not always be available.
        "ntp1.glypnod.com"
        "ntp2.glypnod.com"

        "nts.ntstime.de"
        "svl1.nts.netnod.se"
        "lul1.nts.netnod.se"
        "nts.netnod.se"
        "ntp.3eck.net"
        "time.cifelli.xyz"
        "brazil.time.system76.com"
        "ohio.time.system76.com"
        "oregon.time.system76.com"
        "virginia.time.system76.com"
      ];
    in {
      enable = true;
      enableNTS = true;
      servers = ntsServers;
      enableRTCTrimming = true;
      enableMemoryLocking = true;
      initstepslew = { enabled = true; };
      extraConfig = ''
        # Only update the local clock if at least four sources are considered
        # good.
        minsources 4

        # Where possible, tell the network interface's hardware to timestamp
        # exactly when packets are received/sent to increase accuracy.
        hwtimestamp *
      '';
    };
  };
}
