{ pkgs, config, lib, ... }: {
    home.packages = with pkgs;
    [
      bashInteractiveFHS
      dash
      ksh
      nsh
      oil
      yash
      zsh
      tcsh
      elvish
      fish
      ion
      murex
      nushell
      oh
      powershell
      rc
      xonsh
    ];
}
