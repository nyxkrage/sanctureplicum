{ config
, ... }: {
  config.xdg.dataFile.wallpapers.source = ../wallpapers;

  config.dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;

      disabled-extensions = [ ];

      enabled-extensions = [
        "color-picker@tuberry"
        "just-perfection-desktop@just-perfection"
        "unite@hardpixel.eu"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/shell/extensions/just-perfection" = {
      panel = false;
    };
    "org/gnome/shell/extensions/unite" = {
      hide-window-titlebars = "always";
    };
    "org/gnome/shell/extensions/color-picker" = {
      enable-shortcut = true;
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Mocha";
    };
    "org/gnome/desktop/interface/gtk-theme" = {
      name = "Catppuccin-Mocha";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///${config.xdg.dataHome}/wallpapers/ctp-glitch-portrait.png";
      picture-uri-dark = "file:///${config.xdg.dataHome}/wallpapers/ctp-glitch-portrait.png";
      primary-color = "#212123";
      secondary-color = "#212123";
    };
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///${config.xdg.dataHome}/wallpapers/ctp-glitch-portrait.png";
      primary-color = "#212123";
      secondary-color = "212123";
    };
  };
}
