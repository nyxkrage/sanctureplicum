{ pkgs, config, ... }: {
  services.gitea = rec {
    enable = true;
    appName = "Init System: Gitea";
    package = pkgs.unstable.gitea;
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
      session = {
        COOKIE_SECURE = true;
        PROVIDER = "db";
      };
      service.REGISTER_EMAIL_CONFIRM = true;
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
}
