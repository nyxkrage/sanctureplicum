{ config
, lib
, pkgs
, ...
} : {
  programs.git = {
    enable = true;

    userEmail = "carsten@kragelund.me";
    userName = "Carsten Kragelund";

    signing = {
      key = "CADDADEEC9F753C0!";
      signByDefault = true;
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      "filter \"lfs\"" = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };
  };
}
