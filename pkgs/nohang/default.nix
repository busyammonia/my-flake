{ pkgs, lib, fetchFromGitHub, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "nohang";
  version = "v0.2.0-bf477da";
  src = fetchFromGitHub {
    owner = "hakavlad";
    repo = pname;
    rev = "bf477da";
    sha256 = "sha256-gCGjQoSxY/MprrcpdFrJ4VrsNyruqsUSPrHoy+R07Io=";
  };
  propagatedBuildInputs = with pkgs; [ python3 ];

  installPhase = ''
    runHook preInstall

    PREFIX= DESTDIR=$out SYSTEMDUNITDIR=/lib/systemd/system SYSCONFDIR=/etc make base units

    substituteInPlace $out/lib/systemd/system/nohang.service \
      --replace "ExecStart=" "ExecStart=$out" \
      --replace "#PrivateNetwork" "PrivateNetwork"

    substituteInPlace $out/lib/systemd/system/nohang-desktop.service \
      --replace "ExecStart=" "ExecStart=$out" \
      --replace "#PrivateNetwork" "PrivateNetwork"

    runHook postInstall
  '';
}
