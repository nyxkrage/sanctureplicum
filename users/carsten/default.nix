{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [];
  users.users.carten =
    {
      home =
        if pkgs.stdenv.isLinux
        then "/home/carsten"
        else "/Users/carsten";
    }
    // (
      if pkgs.stdenv.isLinux
      then {
        isNormalUser = true;
        description = "Carsten Kragelund";
        hashedPassword = "$y$j9T$oL/jNqI1yz65OuUnJvpCn1$MC7.xSyvprru7QmqQVsGyBKZf2b4w7R7U.TmfzSBY39";
        shell = pkgs.bash;
        extraGroups = [
          "networkmanager" # Use networks
          "wheel" # Sudoer
          "vboxusers" # VirtualBox
          "docker" # Containers
        ];
      }
      else {}
    );

  home-manager.users.carsten = {
    imports = [
      ./config.nix
    ];

    home = {
      stateVersion = "23.05";

      homeDirectory =
        if pkgs.stdenv.isLinux
        then "/home/carsten"
        else "/Users/carsten";
      username = "carsten";
    };
  };
}
