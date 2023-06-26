{
  pkgs,
  config,
  lib,
  ...
}: let
  optHashedImport = {
    path,
    sha256,
  }: let
    hash = builtins.hashFile "sha256" path;
  in
    if hash != sha256
    then builtins.trace "hash mismatch of ${path}:\nwanted: ${sha256}\ngot: ${hash}" []
    else [path];
in {
  imports = optHashedImport {
    path = ./secrets.nix;
    sha256 = "ed57a9ae39e7cff41216ba87100fa4b129e989a735172d6769a6e7a5fca9b85f";
  };

  services.ryot = rec {
    enable = true;
    database.socket = "/var/run/postgresql";
    cors_urls = ["https://ryot.pid1.sh" "https://ryot.nyx" "http://192.168.1.7:8001"];
    port = 8001;
    https = false;
  };
  networking.firewall.allowedTCPPorts = [config.services.ryot.port];
}
