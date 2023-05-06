{ pkgs, giteaVersion, src, ... }:
let
  escapeSlash = str: builtins.replaceStrings [ "/" ] [ "\\/"] str;
in
pkgs.stdenv.mkDerivation rec {
  pname = "gitea-node-env";
  version = "${giteaVersion}-nyx";

  inherit src;

  nativeBuildInputs = [ pkgs.node2nix ];

  buildPhase = ''
    mkdir nix
    node2nix -i ${src}/package.json -l ${src}/package-lock.json
    sed -r -i 's/src = .+?nix\/store.+?;/src = fetchgit { url = "${escapeSlash src.url}"; rev = "${escapeSlash src.rev}"; hash = "${escapeSlash src.outputHash}"; };/' node-packages.nix
  '';

  installPhase = ''
    mkdir $out
    cp *.nix $out
  '';
}