{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    prelockd
    memavaild
    uresourced
  ];
}
