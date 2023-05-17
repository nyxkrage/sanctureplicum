{ config, lib, pkgs, ... }: {
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    virtualHosts."static" = {
      default = true;
      root = ./.
    }
  };
}
