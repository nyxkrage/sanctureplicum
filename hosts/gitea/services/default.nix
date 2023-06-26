{...}: {
  imports = [
    ./gitea.nix
    ./postgres.nix
    ./nginx.nix
    ./sshd.nix
    ./ryot
  ];
}
