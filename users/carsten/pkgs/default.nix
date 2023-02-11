{ pkgs, config, ... }: {
  imports = [ ];

  programs.bash.enable = true;
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

  services.lorri.enable = true;

  home.packages = with pkgs; [
    (let
      boxedFirefox = writeShellScriptBin "firefox-devedition" ''
    exec boxxy ${firefox-devedition-bin}/bin/firefox-devedition
  '';
    in
      pkgs.symlinkJoin {
        name = "firefox-devedition-bin";
        paths = [
          boxedFirefox
          (firefox-devedition-bin.override { wmClass = "firefox-aurora"; })
        ];
      })

    catppuccin-gtk
    bat
    (discord.override { withOpenASAR = true; })
    direnv
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
    recursive
    numberstation

    # Local
    (callPackage ./rec-mono-nyx.nix {})
    (callPackage ./boxxy.nix {})

    # Rust
    llvmPackages_latest.lld
    llvmPackages_latest.llvm
    rustc
    cargo
    gcc

    # language-servers
    rust-analyzer
    nodePackages.javascript-typescript-langserver
  ];
}
