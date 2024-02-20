{ inputs, outputs, pkgs, lib, secrets, configName, displayForBoot, ... }: {
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

    ./features/${configName}
  ];

  programs.plasma = {
    enable = true;

    configFile = let
      hardcodedFontStuff = "-1,5,57,0,0,0,0,0";
      scale = let
        multiple = 0.0625;
        sc = displayForBoot.scale;
        abs = x: if x < 0 then (-x) else x;
        roundToInt = x:
          let diff = abs (x - builtins.floor x - 0.001);
          in if diff < 0.5 then builtins.floor x else builtins.ceil x;
      in multiple * (roundToInt (sc / multiple));
    in {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "kwinrc" = {
        "Compositing" = { "LatencyPolicy" = "low"; };
        "Xwayland" = { "Scale" = scale; };
      };
      "kdeglobals" = {
        "KDE" = {
          "SingleClick" = "false";
          "AnimationDurationFactor" = 0;
        };
        "KScreen" = { "ScaleFactor" = scale; };
        "General" = {
          "fixed" = "${secrets.fonts."fixed".name},${secrets.fonts."fixed".size},${hardcodedFontStuff},${secrets.fonts."fixed".style}";
          "font" = "${secrets.fonts."general".name},${secrets.fonts."general".size},${hardcodedFontStuff},${secrets.fonts."general".style}";
          "menuFont" = "${secrets.fonts."menu".name},${secrets.fonts."menu".size},${hardcodedFontStuff},${secrets.fonts."menu".style}";
          "smallestReadableFont" = "${secrets.fonts."smallest_readable".name},${secrets.fonts."smallest_readable".size},${hardcodedFontStuff},${secrets.fonts."smallest_readable".style}";
          "toolBarFont" = "${secrets.fonts."toolbar".name},${secrets.fonts."toolbar".size},${hardcodedFontStuff},${secrets.fonts."toolbar".style}";
        };
        "WM" = {
          "activeFont" = "${secrets.fonts."window_title".name},${secrets.fonts."window_title".size},${hardcodedFontStuff},${secrets.fonts."window_title".style}";
        };
      };
      "kxkbrc"."Layout" = {
        "DisplayNames" = ",";
        "LayoutList" = secrets."xkb_layout";
        "Options" = "grp:alt_shift_toggle";
        "ResetOldOptions" = true;
        "Use" = true;
        "VariantList" = ",";
      };
      "powermanagementprofilesrc" = { # Disable all powersaving features
        "AC" = { "icon" = "battery-charging"; };
        "Battery" = { "icon" = "battery-060"; };
        "LowBattery" = { "icon" = "battery-low"; };
      };
      "kscreenlockerrc" = { "Daemon" = { "Autolock" = "false"; }; };
      "kcmfonts" = {
        "General" = {
          "forceFontDPI" = displayForBoot.dpi;
          "forceFontDPIWayland" = displayForBoot.dpi;
        };
      };
    };
  };
}
