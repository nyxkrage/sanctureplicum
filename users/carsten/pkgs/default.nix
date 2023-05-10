{ pkgs, config, osConfig, lib, ... }: {
  imports = [
    ./firefox.nix
    ./gpg.nix
  ];

  programs.bash.enable = true;

  services.lorri.enable = true;

  home.packages = with pkgs; [
    (ripgrep.override { withPCRE2 = true; })
    direnv
    dogdns
    duf
    exa
    fd
    jq
    mcfly
    (if osConfig.graphical then
        pinentry-gtk2
    else
        pinentry-curses)
    unzip
    yq
    wezterm


    # Rust
    cargo
    gcc
    llvmPackages_latest.lld
    llvmPackages_latest.llvm
    rustc

    # JS
    nodejs
    nodePackages.npm

    # Music
    mpc-cli

    # language-servers
    rust-analyzer
  ] ++ lib.lists.optionals osConfig.graphical [
    (discord.override { withOpenASAR = true; })
    catppuccin-gtk
    dconf
    gparted
    numberstation
    pavucontrol
    recursive
    wireplumber
    # Local
    (callPackage ./areon-pro {})
  
    pkgs.nur.repos.sanctureplicum.rec-mono-nyx

    gnomeExtensions.color-picker
    gnomeExtensions.just-perfection
    gnomeExtensions.unite
  ];
}
