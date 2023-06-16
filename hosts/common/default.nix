{
  config,
  lib,
  pkgs,
  ...
}:
with config;
with lib;
with pkgs; {
  imports = [
    ./pkgs.nix
  ];

  # Enable non-free packages
  nixpkgs.config.allowUnfree = true;

  # Configure nix itself
  nix = {
    # Enable nix flakes
    package = pkgs.nixFlakes;

    settings = {
      # Maximum number of jobs that Nix will try to build in parallel
      max-jobs = "auto";

      # Perform builds in a sandboxed environment
      sandbox = true;

      # Enable flakes
      experimental-features = ["nix-command" "flakes"];

      trusted-users = [config.users.users.carsten.name or ""];

      substituters = [
        "https://nix-community.cachix.org"
        "https://sanctureplicum.cachix.org"
        "https://cache.nixos.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "sanctureplicum.cachix.org-1:VztHStNqXs5pFZ0eNVoIfoqCaeKdNKRqkbNb8lYrqQ8"
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";
}
