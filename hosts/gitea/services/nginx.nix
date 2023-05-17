{ config, lib, pkgs, ... }: {
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    virtualHosts."static" = {
      default = true;
      listen = [{
        ssl = false;
        port = 8000;
        addr = "0.0.0.0";
      }];
      root = pkgs.callPackage ../pkgs/cyberchef {};
    };
  };
  networking.firewall.allowedTCPPorts = [ 8000 ];
}
