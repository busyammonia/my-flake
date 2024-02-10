{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib.types) attrsOf coercedTo listOf oneOf str int bool;
  cfg = config.services.prelockd;
  confFile = pkgs.writeText "prelockd.conf" ''
    ${cfg.extraConfig}
  '';
in {

  options.services.prelockd = {
    enable = mkEnableOption (lib.mdDoc "prelockd");

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra configuration directives that should be added to
        `prelockd.conf`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.prelockd = {
      description = "prelockd service user";
      isSystemUser = true;
      home = "/var/lib/prelockd";
      createHome = true;
      group = "prelockd";
    };
    users.groups.prelockd = { };
    systemd.packages = [ pkgs.prelockd ];
    systemd.services.prelockd.wantedBy = [ "multi-user.target" ];
    systemd.services.prelockd.restartTriggers = [ confFile ];
    environment.etc."prelockd.conf".source = confFile;
  };
}
