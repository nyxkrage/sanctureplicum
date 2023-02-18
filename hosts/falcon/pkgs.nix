{ pkgs, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    git
    home-manager
    ntfsprogs
    pipewire
    pulseaudio
    wget
  ];
}
