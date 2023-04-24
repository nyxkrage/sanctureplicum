{ config
, lib
, pkgs
, ...
}: {
  options.graphical = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Whether this is a graphical target";
  };

  config = lib.mkIf config.graphical {
    # Audio
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pipewire
      pulseaudio
    ];

    services.xserver = {
      enable = true;

      layout = "us";
      xkbVariant = "";

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    networking.firewall.allowedTCPPorts = [ 3389 ];
    services.gnome.gnome-remote-desktop.enable = true;
  };
}
