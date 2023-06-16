{ config, lib, pkgs, ... }:

{
  services.mpd = {
    enable = false;
    network.startWhenNeeded = true;
  };
}
