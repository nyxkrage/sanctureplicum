{ pkgs, config, ... }: {
  imports = [ ];

  programs.bash.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
      epkgs.auctex
    ];
  };



  home.packages = with pkgs; [
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
