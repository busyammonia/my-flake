{ lib, stdenvNoCC, fetchurl, zpaqfranz, fd }:

stdenvNoCC.mkDerivation rec {
  pname = "apple-fonts";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/busyammonia/mediaflare/releases/download/apple-fonts-v${version}/applefonts.zpaq";
    sha256 = "sha256-M1hsxsYJbFvVD99N97w6DNJHEtPbFSubYucpwzKDpOQ=";
  };

  nativeBuildInputs = [ zpaqfranz fd ];

  unpackPhase = ''
    runHook preUnpack

    zpaqfranz x ${src}

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    fd -e ttf -x install -Dm644 "{}" -t $out/share/fonts/truetype/ || true \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://developer.apple.com/fonts";
    description = "Apple fonts";
    longDescription = ''
      Apple fonts.
    '';
    license = licenses.unfree;
    maintainers = [ ];
    platforms = platforms.all;
  };
}