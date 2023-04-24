{ ... }: {
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "gitea" ];
    ensureUsers = [
      {
        name = "gitea";
        ensurePermissions = {
          "DATABASE gitea" = "ALL PRIVILEGES";
        };
      }
    ];
}