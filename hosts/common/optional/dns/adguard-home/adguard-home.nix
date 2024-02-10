{ config, pkgs, ... }: {
  services.adguardhome = let
    reliable = [
      "https://dns.cloudflare.com/dns-query"
      "https://dns.google/dns-query"
      "sdns://AQMAAAAAAAAADTkuOS45LjExOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA" # Quad9 DNS
      "sdns://AQIAAAAAAAAAFlsyYTEwOjUwYzA6OjE6ZmZdOjU0NDMgtehE1rg6Pj4SaOtoH76nDePF-mjb1ogUHb8uwGay2volMi5kbnNjcnlwdC51bmZpbHRlcmVkLm5zMS5hZGd1YXJkLmNvbQ" # AdGuard DNS
    ];
    anycast = [
      "https://dns.alidns.com/dns-query"
      "sdns://AQcAAAAAAAAAEzM0LjEwMS4xODUuMTMwOjU0NDMghpbY0AAjPtvOiDsSzDh7Few4-cUrb6D33KwcMl75TtkqMi5kbnNjcnlwdC1jZXJ0LnVuZmlsdGVyZWQuZG5zLmJlYmFzaWQuY29t" # BebasDNS
      "https://dns.cfiec.net/dns-query"
      "sdns://AQAAAAAAAAAADjIwOC42Ny4yMjAuMjIwILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ" # Cisco OpenDNS
      "sdns://AQMAAAAAAAAAEzE4NS4yMjguMTY4LjEwOjg0NDMgvKwy-tVDaRcfCDLWB1AnwyCM7vDo6Z-UGNx3YGXUjykRY2xlYW5icm93c2luZy5vcmc" # CleanBrowsing
      "sdns://AQAAAAAAAAAACjguMjAuMjQ3LjIg0sJUqpYcHsoXmZb1X7yAHwg2xyN5q1J-zaiGG-Dgs7AoMi5kbnNjcnlwdC1jZXJ0LnNoaWVsZC0yLmRuc2J5Y29tb2RvLmNvbQ" # Comodo
      "https://freedns.controld.com/p0"
      "sdns://AQMAAAAAAAAAEjc4LjQ3LjIxMi4yMTE6OTQ0MyBNRN4TaVynkcwkVAbSBrCvr4X3c3Cygz_4VDUcRhhhYx4yLmRuc2NyeXB0LWNlcnQuRGVDbG91ZFVzLXRlc3Q" # DeCloudUS DNS
      "https://doh.dns.sb/dns-query"
      "https://doh.pub/dns-query"
      # "https://doh.mullvad.net/dns-query" # causes problems
      "sdns://AQAAAAAAAAAADzE4MC4xMzEuMTQ0LjE0NCDGC-b_38Dj4-ikI477AO1GXcLPfETOFpE36KZIHdOzLhkyLmRuc2NyeXB0LWNlcnQubmF3YWxhLmlk" # Nawala Childprotection DNS
      "156.154.70.5" # Neustar Recursive DNS
      "https://anycast.dns.nextdns.io"
      "https://ada.openbld.net/dns-query"
      "https://zero.dns0.eu/"
      "https://basic.rethinkdns.com/"
      "195.46.39.39" # Safe DNS
      "sdns://AQMAAAAAAAAADjEwNC4xOTcuMjguMTIxICcgf9USBOg2e0g0AF35_9HTC74qnDNjnm7b-K7ZHUDYIDIuZG5zY3J5cHQtY2VydC5zYWZlc3VyZmVyLmNvLm56" # Safe Surfer
      "https://doh.360.cn/dns-query"
      "64.6.64.6" # Verisign Public DNS
    ];
    russian = [
      "https://dns.comss.one/dns-query" # comms.one (Poland and Russia)
      "https://77.88.8.8:443" # YandexDNS (Russia)
    ];
  in {
    enable = true;
    extraArgs = [ "--no-etc-hosts" ];
    mutableSettings = false;
    settings = {
      dns = {
        bind_hosts = [ "127.0.0.1" "::1" ];
        bind_port = 53;
        anonymize_client_ip = true;
        ratelimit = 0;
        refuse_any = false;
        edns_client_subnet = { enabled = true; };
        fastest_addr = true;
        use_http3_upstreams = true;
        upstream_dns = reliable ++ russian;
        cache_optimistic = true;
        cache_size = 536870912; # 512 MB
        cache_ttl_min = 1800;
        cache_ttl_max = 3600;
        enable_dnssec = true;
        aaaa_disabled = true;
        upstream_timeout = "25s";
        fastest_timeout = "15s";
        fallback_dns = [
          "195.10.195.195" # OpenNIC
          "1.1.1.1"
          "8.8.8.8"
          "9.9.9.9"
        ];
        bootstrap_dns = [ "77.88.8.8" ];
        resolve_clients = false;
        filters = [
          {
            name = "oisd big";
            url = "https://big.oisd.nl";
            enabled = true;
            id = 1;
          }
          {
            name = "EasyList RU";
            url =
              "https://raw.githubusercontent.com/easylist/ruadlist/master/advblock/adservers.txt";
            enabled = true;
            id = 2;
          }
          {
            name = "AdGuard Base filter cryptominers";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/BaseFilter/sections/cryptominers.txt";
            enabled = true;
            id = 3;
          }
          {
            name = "AdGuard Base filter";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/BaseFilter/sections/adservers.txt";
            enabled = true;
            id = 4;
          }
          {
            name = "AdGuard Base filter — first-party servers";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/BaseFilter/sections/adservers_firstparty.txt";
            enabled = true;
            id = 5;
          }
          {
            name = "AdGuard Base filter — foreign servers";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/BaseFilter/sections/foreign.txt";
            enabled = true;
            id = 6;
          }
          {
            name = "AdGuard common Cyrillic filters ad servers";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/CyrillicFilters/common-sections/adservers.txt";
            enabled = true;
            id = 7;
          }
          {
            name =
              "AdGuard common Cyrillic filters ad servers — first-party servers";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/CyrillicFilters/common-sections/adservers_firstparty.txt";
            enabled = true;
            id = 8;
          }
          {
            name = "AdGuard Ukrainian filter — first-party servers";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/CyrillicFilters/UkrainianFilter/sections/adservers_firstparty.txt";
            enabled = true;
            id = 9;
          }
          {
            name = "AdGuard Russian filter — first-party servers";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/CyrillicFilters/RussianFilter/sections/adservers_firstparty.txt";
            enabled = true;
            id = 10;
          }
          {
            name = "AdGuard Belarusian language ad servers";
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/CyrillicFilters/Belarusian/sections/filter.txt";
            enabled = true;
            id = 11;
          }
        ];
        whitelist_filters = [
          {
            name = "1hosts exclusions";
            enabled = true;
            url =
              "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_all.txt";
            id = 1;
          }
          {
            name = "RU Adlist whitelist";
            enabled = true;
            url =
              "https://raw.githubusercontent.com/easylist/ruadlist/master/advblock/whitelist.txt";
            id = 2;
          }
          {
            name = "AdGuard exclusions";
            enabled = true;
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdGuardSDNSFilter/master/Filters/exclusions.txt";
            id = 3;
          }
          {
            name = "AdGuard exceptons";
            enabled = true;
            url =
              "https://raw.githubusercontent.com/AdguardTeam/AdGuardSDNSFilter/master/Filters/exceptions.txt";
            id = 4;
          }
          {
            name = "additional_hosts_duckduckgo";
            enabled = true;
            url =
              "https://raw.githubusercontent.com/DRSDavidSoft/additional-hosts/master/domains/whitelist/duckduckgo.txt";
            id = 5;
          }
          {
            name = "anudeep_whitelist";
            enabled = true;
            url =
              "https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt";
            id = 6;
          }
        ];
      };
    };
  };
}
