{ config
, lib
, pkgs
, ...
}:
with config;
with lib;
with pkgs; 
{
  imports = [
    ./graphical.nix
    ./wsl.nix
    ./pkgs.nix
  ];

  users = {
    defaultUserShell = bash;
    mutableUsers = true;

    users.root = {
      home = "/root";
      uid = ids.uids.root;
      group = "root";
      initialHashedPassword = mkDefault "!";
    };
  };


  # Enable non-free packages
  nixpkgs.config.allowUnfree = true;

  # Configure nix itself
  nix = {
    # Enable nix flakes
    package = pkgs.nixFlakes;

    settings = {
      # Maximum number of concurrent tasks during one build
      # TODO: Dont put in common
      build-cores = 12;

      # Maximum number of jobs that Nix will try to build in parallel
      max-jobs = "auto";

      # Perform builds in a sandboxed environment
      sandbox = true;

      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "us";

  security.pam.loginLimits = [
    # Unlimited amount of processes for root
    {
      domain = "root";
      item = "nproc";
      value = "unlimited";
    }
    # Unlimited open file descriptors
    {
      domain = "*";
      item = "nofile";
      value = "unlimited";
    }
  ];

  networking = {
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;
}
