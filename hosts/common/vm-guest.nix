{ config, lib, pkgs, ... }:

{
  options.vm-guest = lib.mkOption {
    default = config.wsl.enable or false;
    type = lib.types.bool;
    description = "Whether this is a vm guest machine";
  };

  config = lib.mkIf config.vm-guest {
    graphical = false;
  } // lib.mkIf (!config.vm-guest) {
    virtualisation.virtualbox.host.enable = true;
    virtualisation.docker.enable = true;
  };
}
