{ config, pkgs, lib, ... }: {
  config.home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
      DOOMPROFILELOADFILE = "${config.xdg.configHome}/doom-local/profiles.el";
    };
  };

  config.xdg.configFile = {
    "doom" = {
      source = ./doom;
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
          export EMACS="${toString config.home.path}/bin/emacs"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -u
          fi
      ''}";
    };
    #"doom/themes/catppuccin-theme.el" = {
    #  source = config.lib.file.mkOutOfStoreSymlink "~/source/ctp-emacs/catppuccin-theme.el";
    #};
    "emacs" = {
      source = pkgs.fetchgit {
        url = "https://github.com/doomemacs/doomemacs";
        rev = "e96624926d724aff98e862221422cd7124a99c19";
        sha256 = "sha256-C+mQGq/HBDgRkqdwYE/LB3wQd3oIbTQfzldtuhmKVeU=";
      };
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
          export EMACS="${toString config.home.path}/bin/emacs"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -u
          fi
        ''}";
    };
  };
}
