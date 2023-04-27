{ config
, modulesPath
, pkgs
, ...
}: {
  imports = [
    ./hardware.nix

    ../common
    
    ./services
  ];

  users.users.admin = {
    isNormalUser = true;
    description = "Gitea Administrator";
    hashedPassword = "$y$j9T$oL/jNqI1yz65OuUnJvpCn1$MC7.xSyvprru7QmqQVsGyBKZf2b4w7R7U.TmfzSBY39";
    extraGroups = [
      "wheel" # Sudoer
    ];
    shell = pkgs.bash;
  };

  graphical = false;
  vm-guest = true;

  networking.hostName = "gitea";
  networking.firewall.allowedTCPPorts = [ 22 3000 ];

  sops = {
    defaultSopsFile = ../../secrets/gitea.yaml;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
