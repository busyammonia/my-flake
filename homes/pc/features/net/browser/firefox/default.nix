{ pkgs, config, ... }: {
  programs.firefox = {
    enable = true;
    profiles = {
      test = {
        id = 0;
        name = "test";
        extraConfig = ''
          user_pref("general.smoothScroll",   true);
          user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS",   12);
          user_pref("general.smoothScroll.msdPhysics.enabled",                    true);
          user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant",   200);
          user_pref("general.smoothScroll.msdPhysics.regularSpringConstant",       250);
          user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS",           25);
          user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio",     "2.0");
          user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant",      250);
          user_pref("general.smoothScroll.currentVelocityWeighting",             "1.0");
          user_pref("general.smoothScroll.stopDecelerationWeighting",            "1.0");
          user_pref("mousewheel.system_scroll_override.horizontal.factor",         200);
          user_pref("mousewheel.system_scroll_override.vertical.factor",           200);
          user_pref("mousewheel.system_scroll_override_on_root_content.enabled",  true);
          user_pref("mousewheel.system_scroll_override.enabled",                  true);
          user_pref("mousewheel.default.delta_multiplier_x",                       100);
          user_pref("mousewheel.default.delta_multiplier_y",                       100);
          user_pref("mousewheel.default.delta_multiplier_z",                       100);
          user_pref("apz.allow_zooming",                                          true);
          user_pref("apz.force_disable_desktop_zooming_scrollbars",              false);
          user_pref("apz.paint_skipping.enabled",                                 true);
          user_pref("apz.windows.use_direct_manipulation",                        true);
          user_pref("dom.event.wheel-deltaMode-lines.always-disabled",           false);
          user_pref("general.smoothScroll.durationToIntervalRatio",                200);
          user_pref("general.smoothScroll.lines.durationMaxMS",                    150);
          user_pref("general.smoothScroll.lines.durationMinMS",                    150);
          user_pref("general.smoothScroll.other.durationMaxMS",                    150);
          user_pref("general.smoothScroll.other.durationMinMS",                    150);
          user_pref("general.smoothScroll.pages.durationMaxMS",                    150);
          user_pref("general.smoothScroll.pages.durationMinMS",                    150);
          user_pref("general.smoothScroll.pixels.durationMaxMS",                   150);
          user_pref("general.smoothScroll.pixels.durationMinMS",                   150);
          user_pref("general.smoothScroll.scrollbars.durationMaxMS",               150);
          user_pref("general.smoothScroll.scrollbars.durationMinMS",               150);
          user_pref("general.smoothScroll.mouseWheel.durationMaxMS",               200);
          user_pref("general.smoothScroll.mouseWheel.durationMinMS",                50);
          user_pref("layers.async-pan-zoom.enabled",                              true);
          user_pref("layout.css.scroll-behavior.spring-constant",                "250");
          user_pref("mousewheel.transaction.timeout",                             1500);
          user_pref("mousewheel.acceleration.factor",                               10);
          user_pref("mousewheel.acceleration.start",                                -1);
          user_pref("mousewheel.min_line_scroll_amount",                             5);
          user_pref("toolkit.scrollbox.horizontalScrollDistance",                    5);
          user_pref("toolkit.scrollbox.verticalScrollDistance",                      3);

          // allow copying images
          user_pref("dom.events.asyncClipboard.clipboardItem", true);
        '';
      };
    };
  };
}
