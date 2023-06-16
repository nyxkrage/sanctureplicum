{ pkgs, ... }: {
  programs.gpg.enable = true;
  services.gpg-agent.enable = pkgs.stdenv.isLinux;
}
