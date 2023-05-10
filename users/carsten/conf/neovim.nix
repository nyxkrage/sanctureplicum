{ ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
    ];
    extraConfig = ''
      set number relativenumber
      colorscheme catppuccin-latte
    '';
  };
}