{ pkgs ? import <nixpkgs> { }, lib, fetchgit, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "uresourced";
  version = "0.5.4-907d9198";
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/benzea/uresourced.git";
    rev = "907d91989f50842caaf9d681e82a9d6791701927";
    sha256 = "sha256-WTTQYk8tADY9BIfeQ5kFuBbODbRWW8/YCw3vp6O032o=";
  };

  nativeBuildInputs = with pkgs; [ meson pkg-config cmake ninja ];
  buildInputs = with pkgs; [ glib systemd pipewire ];
  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dappmanagement=true"
  ];
}
