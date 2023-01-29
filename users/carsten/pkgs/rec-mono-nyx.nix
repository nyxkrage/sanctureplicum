{ pkgs
, lib
, stdenv
, fetchgit
, fetchurl
, python310Packages
}: stdenv.mkDerivation rec {
  pname = "rec-mono-nyx";
  version = "1.0.0";

  src = fetchgit {
    url = "https://github.com/arrowtype/recursive-code-config.git";
    rev = "c20977eb1f3cd59ca7ce03a740b4745f0d299b27";
    sha256 = "sha256-OaYhOCpjOZI3cIPUNhppqGAQOrGwuQ09tl1pXCtNj5s=";
  };

  recConfig = fetchurl {
    url = "https://gist.github.com/nyxkrage/4b93ee0c8ce9c0cc76c0449d496fafae/raw/fa272d0543859e9303a1ccebc4ad770d167c6a26/RecMonoNyx";
    sha256 = "sha256-AuV49/Zik9O5KpzILk6hcmjCuff1bbogjrbz8qCydyE=";
  };

  nativeBuildInputs = [
    (let
      mach-nix = import (fetchgit {
        url = "https://github.com/DavHau/mach-nix";
        rev = "68a85753555ed67ff53f0d0320e5ac3c725c7400";
        sha256 = "sha256-YIcQtXNQSofFSRDO8Y/uCtXAMguc8HqpY83TstgkH+k=";
      }) {
        python = "python3";
      };
    in
      mach-nix.mkPython {  # replace with mkPythonShell if shell is wanted
        requirements = builtins.readFile "${src}/requirements.txt";
      })
    python310Packages.pip
    python310Packages.setuptools
  ];

  outputs = [ "out" ];
  phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];

  patchPhase = ''
    cp ${recConfig} config.yaml
  '';

  buildPhase = ''
    python3 scripts/instantiate-code-fonts.py
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp fonts/RecMonoNyx/* $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "Recusrive Mono - Nyx Style";
    homepage = "https://spectre.app/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ nyxkrage ];
    platforms = platforms.all;
  };
}
