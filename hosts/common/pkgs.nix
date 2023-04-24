{ pkgs, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    gnupg
    home-manager
    ntfsprogs
    wget
  ];
}
