{ config, pkgs, ... }: {
  services.smartdns = let
    https = {
      reliable = [
        "https://dns.cloudflare.com:443/dns-query" # Cloudflare
        "https://dns.google:443/dns-query" # Google
        "https://dns11.quad9.net:443/dns-query" # Quad9 
        "https://dns.adguard-dns.com:443/dns-query" # Adguard
      ];
      russian = [
        "https://dns.controld.com:443/comss" # comms.one (Poland and Russia)
        "https://common.dot.dns.yandex.net:443/dns-query" # Yandex
        "https://77.88.8.8:443" # Yandex
      ];
      other = [
        "https://freedns.controld.com:443/uncensored" # ControlD
        "https://resolver2.dns.watch:443/dns-query" # DNS.WATCH
        "https://doh.360.cn:443/dns-query" # 360 Secure DNS
        "https://zero.dns0.eu:443" # dns0.eu
        "https://ada.openbld.net/dns-query:443" # OpenBLD.net DNS
        "https://dns.nextdns.io:443" # NextDNS Ultra-low latency
        "https://anycast.dns.nextdns.io:443" # NextDNS Anycast
        "https://basic.rethinkdns.com:443" # RethinkDNS
        "https://dns.digitale-gesellschaft.ch:443/dns-query" # Digitale Gesellschaft DNS
        "https://185.95.218.42:443" # Digitale Gesellschaft DNS
        "https://doh.libredns.gr/dns-query" # LibreDNS
        "https://kaitain.restena.lu:443/dns-query" # Foundation Restena DNS
        "https://158.64.1.29:443/dns-query" # Foundation Restena DNS
        "https://odvr.nic.cz:443/doh" # CZ.NIC ODVR
        "https://private.canadianshield.cira.ca:443/dns-query" # CIRA Canadian Shield DNS
        "https://doh.applied-privacy.net:443/query" # Applied Privacy DNS
        "https://dns.switch.ch:443/dns-query" # SWITCH DNS
      ];
    };
    tls = {
      reliable = [
        "1dot1dot1dot1.cloudflare-dns.com:853" # Cloudflare
        "dns.google:853" # Google
        "dns11.quad9.net:853" # Quad9
        "unfiltered.adguard-dns.com:853" # Adguard
      ];
      russian = [
        "comss.dns.controld.com:853" # comms.one
        "common.dot.dns.yandex.net:853" # Yandex
        "77.88.8.8:853" # Yandex
      ];
      other = [
        "uncensored.freedns.controld.com:853" # ControlD
        "dot.360.cn:853" # 360 Secure DNS 
        "zero.dns0.eu" # dns0.eu
        "ada.openbld.net:853" # OpenBLD.net DNS
        "dns.nextdns.io:853" # NextDNS Ultra-low latency 
        "anycast.dns.nextdns.io:853" # NextDNS Anycast
        "max.rethinkdns.com:853" # RethinkDNS
        "dns.digitale-gesellschaft.ch:853" # Digitalle Gesellschaft DNS
        "185.95.218.43:853" # Digitalle Gesellschaft DNS
        "dot.libredns.gr:853" # LibreDNS
        "116.202.176.26:853" # LibreDNS
        "kaitain.restena.lu:853" # Foundation Restena DNS
        "158.64.1.29:853" # Foundation Restena DNS
        "odvr.nic.cz:853" # CZ.NIC ODVR
        "private.canadianshield.cira.ca:853" # CIRA Canadian Shield DNS
        "dot1.applied-privacy.net:853" # Applied Privacy DNS
        "dns.switch.ch:853" # SWITCH DNS
      ];
    };
    plain = {
      reliable = [
        "1.1.1.1 -b" # Cloudflare
        "1.0.0.1 -b" # Cloudflare
        "8.8.8.8 -b" # Google
        "8.8.4.4 -b" # Google
        "9.9.9.11 -b" # Quad9
        "149.112.112.11 -b" # Quad9
        "94.140.14.141 -b" # Adguard 
        "94.140.14.140 -b" # Adguard
      ];
      russian = [
        #"193.58.251.251" # SkyDNS
        "77.88.8.8" # Yandex
        "77.88.8.1" # Yandex
      ];
      other = [
        "95.85.95.85" # GCore
        "2.56.220.2" # GCore
        "76.76.2.5" # ControlD
        "76.76.10.5" # ControlD
        "64.6.64.6" # Neustar DNS
        "64.6.65.6" # Neustar DNS
        "84.200.69.80" # DNS.WATCH
        "84.200.70.40" # DNS.WATCH
        "80.80.80.80" # Freenom World
        "80.80.81.81" # Freenom World
        "8.26.56.2" # Comodo Secure DNS
        "8.20.247.20" # Comodo Secure DNS
        "64.6.64.6" # Verisign
        "64.6.65.6" # Verisign
        "101.226.4.6" # 360 Secure DNS
        "218.30.118.6" # 360 Secure DNS
        "195.46.39.39" # Safe DNS
        "195.46.39.40" # Safe DNS
        "193.110.81.0" # dns0.eu
        "185.253.5.0" # dns0.eu
        "114.114.114.114" # 114DNS
        "114.114.115.115" # 114DNS
        "88.198.92.222" # LibreDNS
        "193.17.47.1" # CZ.NIC ODVR
        "185.43.135.1" # CZ.NIC ODVR
        "149.112.121.10" # CIRA Canadian Shield DNS
        "149.112.122.10" # CIRA Canadian Shield DNS
        "180.184.1.1" # ByteDance
        "180.184.2.2" # ByteDance
        "130.59.31.248" # SWITCH DNS
      ];
    };
  in {
    enable = true;
    bindPort = 53;
    settings = {
      force-AAAA-SOA = true;
      speed-check-mode = "tcp:443,tcp:80,ping";
      response-mode = "fastest-ip";
      cache-size = 32768;
      cache-persist = true;
      cache-file = "/var/cache/smartdns/smartdns.cache";
      cache-checkpoint-time = 86400;
      serve-expired-prefetch-time = 21600;
      prefetch-domain = true;
      serve-expired = true;
      serve-expired-ttl = 259200;
      serve-expired-reply-ttl = 3;
      edns-client-subnet = "178.70.22.18/24";
      server-https = https.reliable ++ https.russian ++ https.other;
      server-tls = tls.reliable ++ tls.russian ++ tls.other;
      server = plain.reliable ++ plain.russian ++ plain.other;
    };
  };
}
