{ pkgs, ... }: pkgs.unstable.gitea.overrideAttrs (old: rec {
  pname = "gitea";
  version = "1.19.3";

  src = "${import ./build.nix { inherit pkgs; giteaVersion = version; }}/gitea-src-${version}-nyx.tar.gz";
})