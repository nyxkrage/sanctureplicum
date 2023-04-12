{ pkgs
, lib
, stdenv
, fetchgit
, fetchurl
}: stdenv.mkDerivation rec
{
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

  nativeBuildInputs = with pkgs.mach-nix.pkgs; [
    (pkgs.mach-nix.mach-nix.lib."${pkgs.system}".mkPython {
      requirements = builtins.readFile "${src}/requirements.txt";
      _.pyyaml.doInstallCheck = false;
      ignoreDataOutdated = true;
      python = "python39";
    })
    python39Packages.pip
    python39Packages.setuptools
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
