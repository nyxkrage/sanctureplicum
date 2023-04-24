{ config
, lib
, pkgs
, ...
}: {
  config = lib.mkIf (!config.wsl.enable) {
    boot.loader = {
      systemd-boot = {
        enable = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

    networking.nameservers = [ "192.168.1.1" "87.62.97.64" ];

    virtualisation.virtualbox.host.enable = true;
    virtualisation.docker.enable = true;
  };
}
