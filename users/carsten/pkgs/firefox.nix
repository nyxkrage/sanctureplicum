{ osConfig, pkgs, ... }: {
  programs.firefox = {
    enable = osConfig.graphical or true;
    package = if pkgs.stdenv.isLinux then (pkgs.firefox-devedition.override { wmClass = "firefox-aurora"; }) else (pkgs.writeScriptBin "__dummy-firefox" "");
  };
}
