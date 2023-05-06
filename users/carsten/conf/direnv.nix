{ config, lib, pkgs, ... }:

{
  config.programs.bash.initExtra = ''
    eval "$(direnv hook bash)"
  '';
}
