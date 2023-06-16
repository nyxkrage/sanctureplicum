{ config
, osConfig
, lib
, ... }: {
  config = lib.mkIf (osConfig.graphical or false) {
    xdg.dataFile.backgrounds.source = ../wallpapers;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-light";
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

        favorite-apps = [
          "firefox.desktop"
          "emacs.desktop"
        ];
      };
      "org/gnome/shell/extensions/just-perfection" = {
        panel = false;
        panel-in-overview = true;
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
        picture-uri = "file:///${config.xdg.dataHome}/backgrounds/ctp-glitch-portrait.png";
        picture-uri-dark = "file:///${config.xdg.dataHome}/backgrounds/ctp-glitch-portrait.png";
        primary-color = "#212123";
        secondary-color = "#212123";
      };
      "org/gnome/desktop/screensaver" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file:///${config.xdg.dataHome}/backgrounds/ctp-glitch-portrait.png";
        primary-color = "#212123";
        secondary-color = "212123";
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
      };
    };
  };
}
