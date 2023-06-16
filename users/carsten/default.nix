{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [];

  users.users.carsten = {
    home = if pkgs.stdenv.isDarwin then "/Users/carsten" else "/home/carsten";
  } // lib.mkIf pkgs.stdenv.isLinux {
    isNormalUser = true;
    description = "Carsten Kragelund";
    hashedPassword = "$y$j9T$oL/jNqI1yz65OuUnJvpCn1$MC7.xSyvprru7QmqQVsGyBKZf2b4w7R7U.TmfzSBY39";
    shell = pkgs.bash;
    packages = [];
    extraGroups = [
      "networkmanager" # Use networks
      "wheel" # Sudoer
      "vboxusers" # VirtualBox
      "docker" # Containers
    ];
  };


  home-manager.users.carsten = {
    imports = [
      ./config.nix
    ];

    home = {
      stateVersion = builtins.trace config.users.users.carsten.home "23.05";

      homeDirectory = lib.mkIf pkgs.stdenv.isLinux "/home/carsten";
      username = "carsten";
    };
  };
}
