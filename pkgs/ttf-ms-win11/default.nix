{ lib, stdenvNoCC, fetchurl, zpaqfranz }:

stdenvNoCC.mkDerivation rec {
  pname = "ttf-ms-win11";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/busyammonia/mediaflare/releases/download/${version}/ttf_win11.zpaq";
    sha256 = "sha256-mjojAK/piQ28vreDoWZDhRXnlpIkjrcaGYQ5EM0lmiQ=";
  };

  nativeBuildInputs = [ zpaqfranz ];

  unpackPhase = ''
    runHook preUnpack

    zpaqfranz x ${src}

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://docs.microsoft.com/en-us/typography";
    description = "Windows 11 fonts";
    longDescription = ''
      Windows 11 fonts.
    '';
    license = licenses.unfree;
    maintainers = [ ];
    platforms = platforms.all;
  };
}