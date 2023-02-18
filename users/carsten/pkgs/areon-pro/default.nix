{ pkgs
, lib
, stdenv
}: stdenv.mkDerivation rec {
  pname = "areon-pro";
  version = "1.0.0";

  src = ./fonts;

  outputs = [ "out" ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp ${src}/* $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "Areon Pro Font";
    homepage = "https://morisawafonts.com/fonts/621/";
    license = {
      fullName = "Unkown";
      url = "https://morisawafonts.com/fonts/621/";
      free = false;
    };
    maintainers = with maintainers; [ nyxkrage ];
    platforms = platforms.all;
  };
}
