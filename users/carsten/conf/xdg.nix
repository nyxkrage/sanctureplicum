{ config
, lib
, pkgs
, ... }: {
  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";


    userDirs = {
      enable = pkgs.stdenv.isLinux;
      createDirectories = true;

      # Improve the XDG dir locations so they dont clutter up $HOME
      download    = "${config.home.homeDirectory}/downloads";
      desktop     = "${config.home.homeDirectory}/desktop";
      documents   = "${config.home.homeDirectory}/desktop/documents";

      publicShare = "${config.home.homeDirectory}/.local/share/public";
      templates   = "${config.home.homeDirectory}/.local/share/templates";

      music       = "${config.home.homeDirectory}/media/music";
      pictures    = "${config.home.homeDirectory}/media/pictures";
      videos      = "${config.home.homeDirectory}/media/videos";
    };
  };

  home.sessionPath = [
    "${config.home.sessionVariables.CARGO_HOME}/bin"
  ];
  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    WGETRC = "${config.xdg.dataHome}/wget/wgetrc";
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
  };
}
