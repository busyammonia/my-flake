{ pkgs, ... }: rec {
  prelockd = pkgs.callPackage ./prelockd { };
  memavaild = pkgs.callPackage ./memavaild { };
  uresourced = pkgs.callPackage ./uresourced { };
  nohang = pkgs.callPackage ./nohang { };
  zapret = pkgs.callPackage ./zapret { };
  nekoray = pkgs.callPackage ./nekoray { };
  ttf-ms-win11 = pkgs.callPackage ./ttf-ms-win11 { };
  apple-fonts = pkgs.callPackage ./apple-fonts { };
  croscore-fonts = pkgs.callPackage ./croscore-fonts { };
}
