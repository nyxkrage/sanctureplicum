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
      (pkgs.callPackage ./spectre-el.nix {})
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

    # Local
    #(callPackage ./libspectre.nix {})

    # Rust
    llvmPackages_latest.lld
    llvmPackages_latest.llvm
    rustc
    cargo
    gcc

    # language-servers
    rust-analyzer
  ];
}
