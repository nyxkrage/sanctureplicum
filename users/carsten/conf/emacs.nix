{ config, pkgs, lib, ... }: {
  config.home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
      DOOMPROFILELOADFILE = "${config.xdg.configHome}/doom-local/profiles.el";
      EMACS = "${pkgs.emacs}/bin/emacs";
    };
  };

  config.xdg.configFile = {
    "doom" = {
      source = ./doom;
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export EMACS="${pkgs.emacs}/bin/emacs"
          export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -u
          fi
      ''}";
    };
    "emacs" = {
      source = pkgs.fetchgit {
        url = "https://github.com/doomemacs/doomemacs";
        hash = "sha256-C+mQGq/HBDgRkqdwYE/LB3wQd3oIbTQfzldtuhmKVeU=";
      };
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export EMACS="${pkgs.emacs}/bin/emacs"
          export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -u
          fi
        ''}";
    };
  };
}
