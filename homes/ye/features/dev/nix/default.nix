{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    nil
    nixd
    nixel
    nixci
    nixdoc
    nix-ld
    nix-du
    nixbang
    nixfmt
    direnv
    nix-direnv

    flutter
  ];
}
