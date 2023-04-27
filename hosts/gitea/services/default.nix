{ ...} : {
  imports = [
    ./gitea.nix
    ./postgres.nix
    ./sshd.nix
  ];
}
