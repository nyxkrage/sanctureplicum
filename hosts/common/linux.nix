{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./graphical.nix
    ./vm-guest.nix
  ];

  users = {
    defaultUserShell = pkgs.bash;
    mutableUsers = true;

    users.root = {
      home = "/root";
      uid = config.ids.uids.root;
      group = "root";
      initialHashedPassword = lib.mkDefault "!";
    };
  };

  # Configure console keymap
  console.keyMap = "us";
  boot =
    if (!config.wsl.enable or false)
    then {
      networking.nameservers = ["192.168.1.1" "87.62.97.64"];

      loader = {
        systemd-boot = {
          enable = true;
        };

        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
      };
    }
    else {};
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
}
