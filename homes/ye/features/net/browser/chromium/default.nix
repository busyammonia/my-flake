{ pkgs, config, ... }: {
  programs.chromium = let
    flagSwitches = [
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-native-gpu-memory-buffers"
      "--enable-accelerated-2d-canvas"
      "--enable-oop-rasterization"
      "--enable-zero-copy"
      "--disable-beforeunload"
      "--enable-quic"
      "--extension-mime-request-handling=always-prompt-for-install"
      "--fingerprinting-canvas-image-data-noise"
      "--fingerprinting-canvas-measuretext-noise"
      "--fingerprinting-client-rects-noise"
      "--force-punycode-hostnames"
      "--max-connections-per-host=15"
      "--no-pings"
      "--show-avatar-button=always"
      "--enable-smooth-scrolling"
      "--enable-features=MinimalReferrers,NoCrossOriginReferrers,SetIpv6ProbeFalse,WebRTCPipeWireCapturer,WebRtcHideLocalIpsWithMdns"
      "--ozone-platform-hint=auto"
    ];
  in rec {
    enable = true;
    commandLineArgs = flagSwitches;
  };
}
