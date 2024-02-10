{ pkgs, config, ... }: {
  home.packages = with pkgs;
    [
      dnsutils
      bind
      knot-dns
      knot-resolver
      unbound-full
      adguardhome
      coredns
      stubby
      dnscrypt-proxy
      dnscrypt-wrapper
      dnsmasq
      dnsproxy
      pdnsd
      routedns
      smartdns
    ];
}
