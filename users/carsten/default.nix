{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [];
  users.users.carten = {
    home = if lib.traceVal pkgs.stdenv.isLinux then "/home/carsten" else lib.traceVal "/Users/carsten";
  };


  home-manager.users.carsten = {
    imports = [
      ./config.nix
    ];

    home = {
      stateVersion = builtins.trace config.users.users.carsten.home "23.05";

      homeDirectory = if pkgs.stdenv.isLinux then "/home/carsten" else lib.mkForce "/Users/carsten";
      username = "carsten";
    };
  };
}
