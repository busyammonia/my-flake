{ pkgs, ... }: rec {
  prelockd = pkgs.callPackage ./prelockd { };
  memavaild = pkgs.callPackage ./memavaild { };
  uresourced = pkgs.callPackage ./uresourced { };
  nohang = pkgs.callPackage ./nohang { };
  zapret = pkgs.callPackage ./zapret { };
  nekoray = pkgs.callPackage ./nekoray { };
}
