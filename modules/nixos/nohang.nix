{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib.types) attrsOf coercedTo listOf oneOf str int bool;
  cfg = config.services.nohang;
  desktop = cfg.desktop;
  confFile =
    pkgs.writeText (if desktop then "nohang-desktop.conf" else "nohang.conf") ''
      ${cfg.extraConfig}
    '';
  confFileName = (if desktop then "nohang-desktop.conf" else "nohang.conf");
  serviceName = (if desktop then "nohang-desktop" else "nohang");
in {

  options.services.nohang = {
    enable = mkEnableOption (lib.mdDoc "nohang");
    desktop = mkEnableOption (lib.mdDoc ''
      Whether GUI notification support should be enabled.
    '');

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra configuration directives that should be added to
        `nohang.conf` or `nohang-desktop.conf`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.nohang = {
      description = "nohang service user";
      isSystemUser = true;
      home = "/var/lib/nohang";
      createHome = true;
      group = "nohang";
    };
    users.groups.nohang = { };
    systemd.packages = [ pkgs.nohang ];
    systemd.services.${serviceName} = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ confFile ];
    };
    environment.etc."nohang/${confFileName}".source = confFile;
  };
}
