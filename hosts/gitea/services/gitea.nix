{ pkgs, config, ... }: {
  services.gitea = rec {
    enable = true;
    appName = "Init System: Gitea";
    package = pkgs.nur.repos.sanctureplicum.gitea-nyx;
    database = {
      type = "postgres";
      host = "unix:///var/run/postgresql/";
    };
    lfs.enable = true;
    domain = "gitea.pid1.sh";
    rootUrl = "https://" + domain;
    mailerPasswordFile = config.sops.secrets.gitea_mailer_passwd.path;
    settings = {
      server.SSH_PORT = 22007;
      repository = {
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
        DEFAULT_PUSH_CREATE_PRIVATE = true;
      };
      session = {
        COOKIE_SECURE = true;
        PROVIDER = "db";
      };
      service = {
        REGISTER_EMAIL_CONFIRM = true;
        ENABLE_CAPTCHA = true;
      };
      ui = {
        THEMES = "gitea,arc-green,catppuccin-latte-sky";
      };
      mailer = {
        ENABLED = true;
        SMTP_ADDR = "mail.pid1.sh";
        SMTP_PORT = 465;
        FROM = "Root <root@pid1.sh>";
        USER = "root@pid1.sh";
        MAILER_TYPE = "smtp";
        IS_TLS_ENABLED = true;
        SUBJECT_PREFIX = "PID1 Gitea: ";
        SEND_AS_PLAIN_TEXT = true;
      };
    };
  };
  systemd.services.gitea = {
    after = [ "sops-nix.service" ];
  };
  sops.secrets = {
    gitea_mailer_passwd = {
      owner = config.systemd.services.gitea.serviceConfig.User;
    };
  };
  networking.firewall.allowedTCPPorts = [ config.services.gitea.settings.server.HTTP_PORT ];
}
