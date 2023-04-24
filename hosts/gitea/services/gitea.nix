{ pkgs, ... }: {
  services.gitea = rec {
    enable = true;
    package = pkgs.unstable.gitea;
    database = {
      type = "postgres";
      host = "unix:///var/run/postgresql/";
    };
    lfs.enable = true;
    domain = "gitea.pid1.sh";
    rootUrl = "https://" + domain;
    settings = {
      server.SSH_PORT = 22007;
      session.COOKIE_SECURE = true;
      mailer = {
        ENABLED = true;
        SMTP_ADDR = "mail.pid1.sh";
        SMTP_PORT = 587;
        FROM = "Root <root@pid1.sh>";
        USER = "root@pid1.sh";
        PASSWD = "***";
        MAILER_TYPE = "smtp";
        IS_TLS_ENABLED = true;
        SUBJECT_PREFIX = "PID1 Gitea: ";
        SEND_AS_PLAIN_TEXT = true;
      };
    };
  };
}