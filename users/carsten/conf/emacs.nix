{ config, pkgs, lib, ... }: {
  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/profiles.el";
    };
  };
  systemd.user.sessionVariables = config.home.sessionVariables;

  programs.emacs.extraPackages = epkgs: [
    epkgs.vterm
    epkgs.pdf-tools
    epkgs.auctex
    pkgs.nur.repos.sanctureplicum.emacsPackages.spectre-el
  ];

  xdg.configFile = {
    "doom/config.el".source = config.lib.file.mkOutOfStoreSymlink (./doom + "/config.el");
    "doom/init.el".source = config.lib.file.mkOutOfStoreSymlink (./doom + "/init.el");
    "doom/packages.el".source = config.lib.file.mkOutOfStoreSymlink (./doom + "/packages.el");
    "emacs" = {
      source = pkgs.fetchgit {
        url = "https://github.com/doomemacs/doomemacs";
        rev = "07fca786154551f90f36535bfb21f8ca4abd5027";
        sha256 = "sha256-qAI2FbELXIYDMsgMjn19MhYS9WaOxzpcWrATgQW+RP8=";
      };
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
          export EMACS="${toString config.home.path}/bin/emacs"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -e
          fi
        ''}";
    };
  };
}
