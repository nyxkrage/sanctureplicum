{ pkgs, config, ... }: {
  imports = [ ];

  programs.bash.enable = true;

  home.packages = with pkgs; [
    (pkgs.callPackage ./emacs.nix { })
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
