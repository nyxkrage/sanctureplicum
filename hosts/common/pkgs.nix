{ pkgs, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    git-crypt
    gnupg
    home-manager
    ntfsprogs
    wget
  ];
}
