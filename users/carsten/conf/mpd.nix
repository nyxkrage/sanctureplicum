{ config, lib, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
  };
}
