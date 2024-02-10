{ config, ... }: {
  boot = {
    kernelModules = [ "br_netfilter" ];
    kernel = {
      sysctl = {
        "net.bridge.bridge-nf-call-arptables" = 0;
        "net.bridge.bridge-nf-call-ip6tables" = 0;
        "net.bridge.bridge-nf-call-iptables" = 0;
      };
    };
  };
}
