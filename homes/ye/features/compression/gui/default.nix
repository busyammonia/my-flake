{ pkgs, config, ... }: {
  home.packages = with pkgs;
    [
      libsForQt5.ark
      mate.engrampa
      xarchiver
      xarchive    
    ];
}
