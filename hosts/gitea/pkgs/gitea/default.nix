{ pkgs, ... }: pkgs.unstable.gitea.overrideAttrs (old: rec {
  pname = "gitea";
  version = "1.19.3-nyx";

  src = "${import ./build.nix { inherit pkgs; }}/gitea-src-${version}.tar.gz";
})