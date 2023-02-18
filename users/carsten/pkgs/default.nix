{ pkgs, config, ... }: {
  imports = [ ];

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };
    initExtra = ''
      PROMPT='%n@%m %~ %# '
    '';
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGit;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
      epkgs.auctex
      (pkgs.callPackage ./spectre-el.nix {})
    ];
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSshSupport = true;
    sshKeys = [ "64AB8617FA4EC63E93A4E1A94AE9B14AF64A86C6" "C54678A60A531F2144EC2391CF888696261ED167" ];
  };

  services.lorri.enable = true;

  home.packages = with pkgs; [
  #   (let
  #     boxedFirefox = writeShellScriptBin "firefox-devedition" ''
  #   exec boxxy ${firefox-devedition-bin}/bin/firefox-devedition $@
  # '';
  #   in
  #     pkgs.symlinkJoin {
  #       name = "firefox-devedition-bin";
  #       paths = [
  #         boxedFirefox
  #         (firefox-devedition-bin.override { wmClass = "firefox-aurora"; })
  #       ];
  #     })

    (discord.override { withOpenASAR = true; })
    (firefox-devedition-bin.override { wmClass = "firefox-aurora"; })
    (ripgrep.override { withPCRE2 = true; })
    bat
    catppuccin-gtk
    dconf
    direnv
    dogdns
    duf
    exa
    fd
    git-lfs
    gnomeExtensions.color-picker
    gnomeExtensions.just-perfection
    gnomeExtensions.unite
    gnupg
    gparted
    jq
    mcfly
    numberstation
    pavucontrol
    pinentry-gtk2
    recursive
    unzip
    wireplumber
    yq

    # Local
    (callPackage ./areon-pro {})
    (callPackage ./boxxy.nix {})
    (callPackage ./rec-mono-nyx.nix {})

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
  ];
}
