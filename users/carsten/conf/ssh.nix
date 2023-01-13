{ config
, lib
, pkgs
, ...
} : {
  config.services.gpg-agent = {
    enable = true;
    sshKeys = [ "64AB8617FA4EC63E93A4E1A94AE9B14AF64A86C6" ];
  };

  config.programs.bash.initExtra = ''
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
}
