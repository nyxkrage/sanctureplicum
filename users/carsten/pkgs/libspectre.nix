{ lib, stdenv, fetchgit, libsodium, meson, pkg-config, ninja }:

stdenv.mkDerivation rec {
  pname = "libspectre";
  version = "1.0.0";

  src = fetchgit {
     url = "https://github.com/nyxkrage/spectre-lib";
     rev = "da65b8ac4502eb7ec0f0ce57c5d6d6bf79b1d3e4";
     sha256 = "sha256-iHhUPNl1GkVLRJNAMqvyDpTU1dXUDWnwgFOnRGo7Ikc=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    libsodium
  ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "A modern and easy-to-use crypto library";
    homepage = "https://spectre.app/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ nyxkrage ];
    platforms = platforms.all;
  };
}
