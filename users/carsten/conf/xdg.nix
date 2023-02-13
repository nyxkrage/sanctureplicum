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
      documents   = "$HOME/desktop/documents";

      publicShare = "$HOME/.local/share/public";
      templates   = "$HOME/.local/share/templates";

      music       = "$HOME/media/music";
      pictures    = "$HOME/media/pictures";
      videos      = "$HOME/media/videos";
    };
  };

  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    HISTFILE = "${config.xdg.dataHome}/bash/histfile";
    WGETRC = "${config.xdg.dataHome}/wget/wgetrc";
  };
}
