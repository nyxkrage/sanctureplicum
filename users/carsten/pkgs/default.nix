{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}: {
  imports = [
    ./firefox.nix
    ./gpg.nix
    ./editors.nix
  ];

  programs.bash.enable = true;

  services.lorri.enable = pkgs.stdenv.isLinux;

  home.packages = with pkgs;
    [
      (ripgrep.override {withPCRE2 = true;})
      direnv
      dogdns
      duf
      exa
      fd
      jq
      mcfly
      (
        if (osConfig.graphical or true)
        then pinentry-gtk2
        else pinentry-curses
      )
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
    ]
    ++ lib.lists.optionals (osConfig.graphical or true) [
      recursive
      # Local
      (callPackage ./areon-pro {})

      pkgs.nur.repos.sanctureplicum.rec-mono-nyx

    ] ++ lib.lists.optionals (osConfig.graphical or true && pkgs.stdenv.isLinux) [
      (discord.override {withOpenASAR = true;})
      catppuccin-gtk
      pavucontrol
      dconf
      gparted
      numberstation
      wireplumber
      gnomeExtensions.color-picker
      gnomeExtensions.just-perfection
      gnomeExtensions.unite
    ];
}
