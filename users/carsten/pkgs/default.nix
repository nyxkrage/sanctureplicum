{ pkgs, config, ... }: {
  imports = [ ];

  programs.bash.enable = true;

  home.packages = with pkgs; [
    ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
      epkgs.vterm
    ]))
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
