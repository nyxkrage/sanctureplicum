{
  pkgs,
  config,
  lib,
  ...
}: {
  imports =
    lib.optional ((lib.traceVal (builtins.hashFile "sha256" ./secrets.nix)) == "") ./secrets.nix;

  services.ryot = rec {
    enable = true;
    database.socket = "/var/run/postgresql";
    cors_urls = ["https://ryot.pid1.sh" "https://ryot.nyx" "http://192.168.1.7:8001"];
    port = 8001;
    https = false;
  };
  networking.firewall.allowedTCPPorts = [config.services.ryot.port];
}
