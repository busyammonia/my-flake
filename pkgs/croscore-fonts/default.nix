{ lib, stdenvNoCC, fetchurl, zpaqfranz, fd }:

stdenvNoCC.mkDerivation rec {
  pname = "croscore-fonts";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/busyammonia/mediaflare/releases/download/${pname}-v${version}/${pname}.zpaq";
    sha256 = "sha256-gJDtmvYm15GWT+2JMDq+Cl7NgOujulpAvFPtv1UP8fo=";
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
    fd -e otf -x install -Dm644 "{}" -t $out/share/fonts/opentype/ || true \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://en.wikipedia.org/wiki/Croscore_fonts";
    description = "Croscore fonts";
    longDescription = ''
      Croscore core and extra fonts.
    '';
    license = licenses.unfree;
    maintainers = [ ];
    platforms = platforms.all;
  };
}