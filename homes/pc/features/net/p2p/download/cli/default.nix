{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    aria
    yt-dlp
    wget
    wget2
    curlFull
    axel
    pyload-ng
  ];
}
