{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib.types) attrsOf coercedTo listOf oneOf str int bool;
  cfg = config.services.uresourced;
  confFile = pkgs.writeText "uresourced.conf" ''
    ${cfg.extraConfig}
  '';
in {

  options.services.uresourced = {
    enable = mkEnableOption (lib.mdDoc "uresourced");

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra configuration directives that should be added to
        `uresourced.conf`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.uresourced = {
      description = "uresourced service user";
      isSystemUser = true;
      group = "uresourced";
    };
    users.groups.uresourced = { };
    systemd.packages = [ pkgs.uresourced ];
    systemd.services.uresourced.wantedBy = [ "multi-user.target" ];
    environment.etc."uresourced.conf".source = confFile;
  };
}
