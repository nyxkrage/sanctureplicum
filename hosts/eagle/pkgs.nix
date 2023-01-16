{ pkgs, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    (firefox-devedition-bin.override { wmClass = "firefox-aurora"; })
    dconf
    git
    git-lfs
    gnomeExtensions.color-picker
    gnomeExtensions.just-perfection
    gnomeExtensions.unite
    gnupg
    home-manager
    ntfsprogs
    pinentry-gtk2
    pipewire
    pulseaudio
    unzip
    vim
    wget
    wireplumber
  ];
}
