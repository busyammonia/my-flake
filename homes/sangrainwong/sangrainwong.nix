{ inputs, outputs, pkgs, lib, ... }: {
  imports = [
    ./global

    ./features/basic
    ./features/desktop/common
    ./features/compression
    ./features/image_optimization
    ./features/dns
    ./features/net
    ./features/secrets_management
    ./features/hardware_monitor
    ./features/vscode
    ./features/dev
    ./features/shell

    ./features/sangrainwong
  ];

  programs.plasma = {
    enable = true;

    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "kwinrc"."Compositing"."LatencyPolicy" = "low";
      "kdeglobals"."KDE"."SingleClick" = "false";
      "kdeglobals"."KDE"."AnimationDurationFactor" = 0;
      "kxkbrc"."Layout" = {
        "DisplayNames" = ",";
        "LayoutList" = "us,ru";
        "Options" = "grp:alt_shift_toggle";
        "ResetOldOptions" = true;
        "Use" = true;
        "VariantList" = ",";
      };
      "powermanagementprofilesrc" = { # Disable all powersaving features
        "AC" = {
          "icon" = "battery-charging";
        };
        "Battery" = {
          "icon" = "battery-060";
        };
        "LowBattery" = {
          "icon" = "battery-low";
        };
      };
      "kscreenlockerrc" = {
        "Daemon" = {
          "Autolock" = "false";
        };
      };
    };
  };
}
