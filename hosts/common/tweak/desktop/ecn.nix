{ config, ... }: {
  boot = {
    kernel = {
      sysctl = {
        "net.ipv4.tcp_ecn" = 2;
      };
    };
  };
}
