{ config
, modulesPath
, pkgs
, ...
}: {
  imports = [
    ./hardware.nix
    (import ../common/network.nix { hostName = "gitea"; macAddresses = [ "00:50:50:00:00:01" ]; ipv4Addresses = [ "192.168.1.7" ]; })
    ../common
    
    ./services
  ];

  # networking = builtins.trace ((pkgs.callPackage ../common/network.nix {}) { hostName = "gitea"; macAddresses = [ "00:50:50:00:00:01" ]; ipv4Addresses = [ "192.168.1.7" ]; }) {};

  users.users.admin = {
    isNormalUser = true;
    description = "Gitea Administrator";
    hashedPassword = "$y$j9T$oL/jNqI1yz65OuUnJvpCn1$MC7.xSyvprru7QmqQVsGyBKZf2b4w7R7U.TmfzSBY39";
    extraGroups = [
      "wheel" # Sudoer
    ];
    shell = pkgs.bash;
  };
  nix.settings.build-cores = 4;

  graphical = false;
  vm-guest = true;

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
