{ ... }: {
  imports = [ 
    ./direnv.nix
    ./emacs.nix
    ./git.nix
    ./gnome.nix
    ./ssh.nix
    ./xdg.nix
    ./firefox.nix
    ./mpd.nix
    ./gpg.nix
  ];
}
