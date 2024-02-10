{ pkgs ? import <nixpkgs> { }, lib, fetchFromGitHub, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "memavaild";
  version = "v0.5-de0870e";
  src = fetchFromGitHub {
    owner = "hakavlad";
    repo = pname;
    rev = "55352fe";
    sha256 = "sha256-qzEQ8iT4TlOeXv0ihyr7Z+oKfsGXIlkKOURkp9PoYFM=";
  };
  propagatedBuildInputs = with pkgs; [ python3 ];
  installPhase = ''
    runHook preInstall

    PREFIX= DESTDIR=$out SYSTEMDUNITDIR=/lib/systemd/system SYSCONFDIR=/etc make base units

    substituteInPlace $out/lib/systemd/system/memavaild.service \
      --replace "ExecStart=" "ExecStart=$out"

    runHook postInstall
  '';
}
