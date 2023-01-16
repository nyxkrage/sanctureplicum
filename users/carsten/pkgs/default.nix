{ pkgs, config, ... }: {
  imports = [ ];

  programs.bash.enable = true;

  home.packages = with pkgs; [
    (let wrapped = pkgs.writeShellScriptBin "emacs" ''
        export DOOMDIR=$HOME/.config/doom
        export DOOMLOCALDIR=$HOME/.config/doom-local
        export EMACS=${pkgs.emacs}/bin/emacs
        exec "${pkgs.emacs}/bin/emacs" $@
      '';
    in pkgs.symlinkJoin {
      name = "emacs";
      paths = [
        wrapped
        ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
          epkgs.vterm
        ]))
      ];
    })
    catppuccin-gtk
    bat
    (discord.override { withOpenASAR = true; })
    dogdns
    duf
    exa
    fd
    gparted
    jq
    mcfly
    pavucontrol
    (ripgrep.override { withPCRE2 = true; })
    yq
  ];
}
