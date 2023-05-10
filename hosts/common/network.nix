{ hostName, macAddresses, ipv4Addresses }: { lib, ... }: let
  inherit (builtins) map toString listToAttrs;
  inherit (lib) imap1 concatImapStrings;
in {
  networking = {
    inherit hostName;
    useDHCP = false;
    interfaces = listToAttrs (imap1 (i: macAddress: {
      name = "enc${toString i}";
      value = {
        inherit macAddress;
        ipv4.addresses = map (address: {
          inherit address;
          prefixLength = 24;
        }) ipv4Addresses;
      };
    }) macAddresses);
    defaultGateway.address = "192.168.1.1";
  };
  services.udev.extraRules = concatImapStrings (i: macAddress: ''
    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="${macAddress}", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="enc${toString i}"
  '') macAddresses;
}