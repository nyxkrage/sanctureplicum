{ config, lib, pkgs, ... }: {
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;

  homebrew = {
    enable = true;
    casks = [
      "discord"
      "firefox-developer-edition"
      "alfred"
      "ukelele"
    ];
    taps = ["homebrew/cask" "homebrew/cask-versions" ];
  };
}

