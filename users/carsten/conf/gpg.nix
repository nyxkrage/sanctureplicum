{ osConfig, config, ... }: {
  programs.gpg = {
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    pinentryFlavor = if osConfig.graphical then "gtk2" else "curses";
    enableSshSupport = true;
    enableBashIntegration = true;
    sshKeys = [ "64AB8617FA4EC63E93A4E1A94AE9B14AF64A86C6" "C54678A60A531F2144EC2391CF888696261ED167" ];
  };
}
