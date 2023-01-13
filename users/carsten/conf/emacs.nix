{ config, pkgs, ... }: {
  config.home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
      DOOMPROFILELOADFILE = "${config.xdg.configHome}/doom-local/profiles.el";
    };
  };

  config.xdg.desktopEntries.emacs = {
    name = "Emacs";

    genericName = "Text Editor";
    comment = "Edit Text";
    mimeType = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];

    exec = "emacs %F";
    icon = "emacs";

    type = "Application";
    terminal = false;

    categories = [ "Development" ];

    startupNotify = true;
    settings.StartupWMClass = "Emacs";
  };

  config.xdg.configFile = {
    "doom" = {
      source = ./doom;
    };
    "emacs" = {
      source = pkgs.fetchgit {
        url = "https://github.com/doomemacs/doomemacs";
        hash = "sha256-C+mQGq/HBDgRkqdwYE/LB3wQd3oIbTQfzldtuhmKVeU=";
      };
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export EMACS="${pkgs.emacs}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom -y install
          else
            ${config.xdg.configHome}/emacs/bin/doom -y sync -u
          fi
        ''}";
    };
  };
}
