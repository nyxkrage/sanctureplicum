{ config, lib, ... }: {
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
}

