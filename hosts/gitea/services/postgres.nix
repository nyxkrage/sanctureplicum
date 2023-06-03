{...}: {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureDatabases = ["gitea" "ryot"];
    ensureUsers = [
      {
        name = "ryot";
        ensurePermissions = {
          "DATABASE ryot" = "ALL PRIVILEGES";
        };
      }
      {
        name = "gitea";
        ensurePermissions = {
          "DATABASE gitea" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  networking.firewall.allowedTCPPorts = [5432 8001];
}
