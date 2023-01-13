{ config
, lib
, pkgs
, ... }: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;

      # Improve the XDG dir locations so they dont clutter up $HOME
      download    = "$HOME/downloads";
      desktop     = "$HOME/desktop";
      documents   = "$HOME/documents";

      publicShare = "$HOME/etc/public";
      templates   = "$HOME/etc/templates";

      music       = "$HOME/media/music";
      pictures    = "$HOME/media/pictures";
      videos      = "$HOME/media/videos";
    };
  };
}
