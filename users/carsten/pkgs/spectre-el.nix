{ lib, stdenv, fetchgit, meson, ninja, pkg-config, callPackage, emacs }:

stdenv.mkDerivation rec {
  pname = "spectre-emacs";
  version = "0.3.0";

  src = fetchgit {
    url = "https://github.com/nyxkrage/spectre-emacs";
    rev = "41a9258710ec21fcbb94c80f456da04c9760cf45";
    sha256 = "sha256-zd2yR3y0GnCC0CGx8ij+Kag+8TRRxOqhUwQ2T5ncDEI=";
  };

  depsBuildBuild = [
    pkg-config
  ];


  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    emacs
  ];

  buildInputs = [
    (callPackage ./libspectre.nix {})
  ];

  configurePhase = ''
    meson setup build --libdir $out/share/emacs/site-lisp/elpa/${pname}-${version}
    cd build
  '';

  buildPhase = ''
    ninja
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp/elpa/${pname}-${version}
    ninja install
    cd ..
    cp spectre.el $out/share/emacs/site-lisp/elpa/${pname}-${version}
  '';

  outputs = [ "out" ];

  enableParallelBuilding = true;

  doCheck = true;
}
