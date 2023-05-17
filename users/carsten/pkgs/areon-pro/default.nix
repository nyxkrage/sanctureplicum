{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
}: stdenv.mkDerivation rec {
  pname = "areon-pro";
  version = "1.0.0";

  src = ./fonts;

  outputs = [ "out" ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    if file ${src}/* | grep 'TrueType Font data' >/dev/null; then
      cp ${src}/* $out/share/fonts/truetype
    else
      printf "\033[0;33m[WARN]\033[0m: AreonPro fonts are propietary and are encrypted, please run git crypt unlock and rebuild to make sure they are properly copied to the store"
    fi
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
