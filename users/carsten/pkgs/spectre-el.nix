{ lib, stdenv, fetchgit, meson, ninja, pkg-config, callPackage, emacs }:

stdenv.mkDerivation rec {
  pname = "spectre-emacs";
  version = "0.1.0";

  src = fetchgit {
    url = "https://github.com/nyxkrage/spectre-emacs";
    rev = "ceb5898f5f96c200a029349c83168132ac6e309f";
    sha256 = "sha256-3JLoHUZ+5jBeGeOhkOmQ/GDMG4q266GX3LiB0GNgbiw=";
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
