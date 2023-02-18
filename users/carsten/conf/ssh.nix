{ config
, lib
, pkgs
, ...
} : {
  config.programs.zsh.initExtra = ''
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
}
