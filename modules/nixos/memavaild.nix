{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib.types) attrsOf coercedTo listOf oneOf str int bool;
  cfg = config.services.memavaild;
  confFile = pkgs.writeText "memavaild.conf" ''
    ${cfg.extraConfig}
  '';
in {

  options.services.memavaild = {
    enable = mkEnableOption (lib.mdDoc "memavaild");

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra configuration directives that should be added to
        `memavaild.conf`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.memavaild = {
      description = "memavaild service user";
      isSystemUser = true;
      group = "memavaild";
    };
    users.groups.memavaild = { };
    systemd.packages = [ pkgs.memavaild ];
    systemd.services.memavaild.wantedBy = [ "multi-user.target" ];
    systemd.services.memavaild.restartTriggers = [ confFile ];
    environment.etc."memavaild.conf".source = confFile;
  };
}
