{ config, lib, pkgs, ... }:
{
  config.xdg.configFile = {
    "boxxy/boxxy.yaml".text = builtins.toJSON {
      rules = [
        {
          name = "Test tmux";
          target = "~/.tmux.conf";
          rewrite = "~/.cache/tmux.conf";
          mode = "file";
        }
        {
          name = ".mozilla Directory";
          target = "~/.mozilla";
          rewrite = "~/.local/share/";
          mode = "directory";
        }
      ];
    };
  };
}
