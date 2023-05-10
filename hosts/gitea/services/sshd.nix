{ config, ... }: {
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };
  networking.firewall.allowedTCPPorts = config.services.openssh.ports;
}
