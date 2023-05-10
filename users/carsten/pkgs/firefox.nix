{ osConfig, pkgs, ... }: {
  programs.firefox = {
    enable = osConfig.graphical;
    package = (pkgs.firefox-devedition-bin.override { wmClass = "firefox-aurora"; });
  };
}