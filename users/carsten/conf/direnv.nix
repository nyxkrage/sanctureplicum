{ config, lib, pkgs, ... }:

{
  config.programs.zsh.initExtra = ''
    eval "$(direnv hook zsh)"
  '';
}
