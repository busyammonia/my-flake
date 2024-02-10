{ config, ... }: {
  boot = {
    kernel = {
      sysctl = {
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
    };
    kernelModules = [ "tcp_bbr" ];
  };
}

