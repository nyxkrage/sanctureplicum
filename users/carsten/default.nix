{ config
, pkgs
, ...
}: {
  imports = [ ];

  users.users.carsten = {
    isNormalUser = true;
    description = "Carsten Kragelund";
    hashedPassword = "$y$j9T$oL/jNqI1yz65OuUnJvpCn1$MC7.xSyvprru7QmqQVsGyBKZf2b4w7R7U.TmfzSBY39";
    extraGroups = [
      "networkmanager" # Use networks
      "wheel" # Sudoer
    ];
    shell = pkgs.zsh;
    packages = [ ];
  };

  home-manager.users.carsten = {
    imports = [
      ./config.nix
    ];

    home = {
      inherit (config.system) stateVersion;

      username = "carsten";
      homeDirectory = "/home/carsten";
    };
  };
}
