{ ... }: {
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };
  networking.firewall.allowedTCPPorts = [ 22 ];
}
