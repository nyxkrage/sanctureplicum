{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    (import ../common/network.nix {
      hostName = "boulder";
      macAddresses = ["00:50:50:00:00:02"];
      ipv4Addresses = ["192.168.1.8"];
    })
    ../common
  ];


  nix.settings.build-cores = 4;

  graphical = false;
  vm-guest = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
