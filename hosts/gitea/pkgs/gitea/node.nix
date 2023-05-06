{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "gitea-node-env";
  version = "1.19.3-nyx";

  src = pkgs.fetchgit  {
     url = "https://github.com/nyxkrage/gitea";
     rev = "1.19.3";
     hash = "sha256-KQEBq1BFQRLJW9fJq4W1sOsAqOCfNHKY/+cT8rkXxv4=";
  };

  nativeBuildInputs = [ pkgs.node2nix ];

  buildPhase = ''
    mkdir nix
    node2nix -i ${src}/package.json -l ${src}/package-lock.json
    sed -r -i 's/src = .+?nix\/store.+?;/src = fetchgit { url = "https:\/\/github.com\/nyxkrage\/gitea"; rev = "1.19.3"; hash = "sha256-KQEBq1BFQRLJW9fJq4W1sOsAqOCfNHKY\/+cT8rkXxv4="; };/' node-packages.nix
  '';

  installPhase = ''
    mkdir $out
    cp *.nix $out
  '';
}