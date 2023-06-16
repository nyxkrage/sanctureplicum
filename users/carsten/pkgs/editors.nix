{ pkgs, ... }: {
  programs.neovim.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };
}
