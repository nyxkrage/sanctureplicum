{ pkgs, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    git-crypt
    cachix
    gnupg
    home-manager
    ntfsprogs
    wget
  ];
}
