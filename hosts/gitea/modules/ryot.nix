{
  config,
  lib,
  options,
  pkgs,
  craneLib,
  ...
}:
with lib;
with builtins; let
  pgHost = {
    host,
    socket,
    name,
    port,
    user,
    password,
    ...
  }: "postgres://${user}${
    if password != ""
    then ":${password}"
    else ""
  }@${
    if socket == null
    then "${host}:${port}"
    else replaceStrings ["/"] ["%%2F"] socket
  }/${name}";
  cfg = config.services.ryot;
  pg = config.services.postgresql;
in {
  options.services.ryot = {
    enable = mkEnableOption "ryot";

    package = mkOption {
      default = pkgs.unstable.callPackage ../pkgs/ryot {inherit craneLib;};
      type = types.package;
      defaultText = literalExpression "pkgs.callPackage ../pkgs/ryot {}";
      description = mdDoc "ryot derivation to use";
    };

    database = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = mdDoc "Database host address.";
      };

      port = mkOption {
        type = types.port;
        default = pg.port or 5432;
        defaultText = literalExpression "config.postgresql.port or 5432";
        description = mdDoc "Database host port.";
      };

      socket = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/run/postgresql";
        description = mdDoc "Path to the unix socket file to use for authentication.";
      };

      name = mkOption {
        type = types.str;
        default = "ryot";
        description = mdDoc "Database name.";
      };

      user = mkOption {
        type = types.str;
        default = "ryot";
        description = mdDoc "Database user.";
      };

      password = mkOption {
        type = types.str;
        default = "";
        description = mdDoc ''
          The password corresponding to {option}`database.user`.
          Warning: this is stored in cleartext in the Nix store!
        '';
      };

      createDatabase = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to create a local database automatically.";
      };
    };

    user = mkOption {
      type = types.str;
      default = "ryot";
      description = lib.mdDoc "User account under which ryot runs.";
    };
    group = mkOption {
      type = types.str;
      default = "ryot";
      description = lib.mdDoc "Group under which ryot runs.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = mdDoc "The port the web interface should listen on";
    };

    https = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc "Whether the site is served over https";
    };

    cors_urls = mkOption {
      type = types.listOf types.str;
      default = [];
      description = mdDoc ''A list of URLs for CORS.'';
    };

    settings = {
      audio_books = {
        audible = {
          url = mkOption {
            type = types.str;
            default = "https://api.audible.com/1.0/catalog/products/";
            description = mdDoc "The url to make requests for getting metadata from Audible.";
          };
        };
      };
      books = {
        openlibrary = {
          url = mkOption {
            type = types.str;
            default = "https://openlibrary.org";
            description = mdDoc "The url to make requests for getting metadata from Openlibrary.";
          };
          cover_image_url = mkOption {
            type = types.str;
            default = "https://covers.openlibrary.org/b";
            description = mdDoc "The url for getting images from Openlibrary.";
          };
          cover_image_size = mkOption {
            type = types.enum ["S" "M" "L"];
            default = "M";
            description = mdDoc "The image sizes to fetch from Openlibrary.";
          };
        };
      };
      movies = {
        tmdb = {
          url = mkOption {
            type = types.str;
            default = "https://api.themoviedb.org/3/";
            description = mdDoc "The url to make requests for getting metadata about shows/movies.";
          };
          access_token = mkOption {
            type = types.str;
            default = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZGVlOTZjMjc0OGVhY2U0NzU2MGJkMWU4YzE5NTljMCIsInN1YiI6IjY0NDRiYmE4MmM2YjdiMDRiZTdlZDJmNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZZZNJMXStvAOPJlT0hOBVPSTppFAK3mcUpmbJsExIq4";
            description = mdDoc "The access token for the TMDB API.";
          };
        };
      };
      shows = {
        tmdb = {
          url = mkOption {
            type = types.str;
            default = "https://api.themoviedb.org/3/";
            description = mdDoc "The url to make requests for getting metadata about shows/movies.";
          };
          access_token = mkOption {
            type = types.str;
            default = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZGVlOTZjMjc0OGVhY2U0NzU2MGJkMWU4YzE5NTljMCIsInN1YiI6IjY0NDRiYmE4MmM2YjdiMDRiZTdlZDJmNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZZZNJMXStvAOPJlT0hOBVPSTppFAK3mcUpmbJsExIq4";
            description = mdDoc "The access token for the TMDB API.";
          };
        };
      };
      podcasts = {
        listennotes = {
          url = mkOption {
            type = types.str;
            default = "https://listen-api.listennotes.com/api/v2/";
            description = mdDoc "The url to make requests for getting metadata about podcasts.";
          };
          api_token = mkOption {
            type = types.str;
            default = "";
            description = mdDoc "The access token for the Listennotes API.";
          };
          user_agent = mkOption {
            type = types.str;
            default = "";
            description = mdDoc "The user agent used for the Listennotes API.";
          };
        };
      };
      scheduler = {
        user_cleanup_every = mkOption {
          type = types.int;
          default = 10;
          description = mdDoc "Deploy a job every x minutes that performs user cleanup and summary calculation.";
        };
        rate_limit_num = mkOption {
          type = types.int;
          default = 5;
          description = mdDoc "The number of jobs to process every 5 seconds when updating metadata in the background.";
        };
      };
      video_games = {
        twitch = {
          client_id = mkOption {
            type = types.str;
            default = "";
            description = mdDoc "The client ID issues by Twitch. Required to enable video games tracking. [More information](https://github.com/IgnisDa/ryot/blob/main/docs/guides/video-games.md)";
          };
          client_secret = mkOption {
            type = types.str;
            default = "";
            description = mdDoc "The client secret issued by Twitch.";
          };
          access_token_url = mkOption {
            type = types.str;
            default = "https://id.twitch.tv/oauth2/token";
            description = mdDoc "The endpoint that issues access keys for IGDB.";
          };
        };
        igdb = {
          url = mkOption {
            type = types.str;
            default = "https://api.igdb.com/v4/";
            description = mdDoc "The url to make requests for getting metadata about video games.";
          };
          image_url = mkOption {
            type = types.str;
            default = "https://images.igdb.com/igdb/image/upload/";
            description = mdDoc "The url for getting images from IGDB.";
          };
          image_size = mkOption {
            type = types.enum ["t_original"];
            default = "t_original";
            description = mdDoc "The image sizes to fetch from IGDB.";
          };
        };
      };
      users = {
        allow_changing_username = mkOption {
          type = types.bool;
          default = true;
          description = mdDoc "Whether users will be allowed to change their username in their profile settings.";
        };
        token_valid_for_days = mkOption {
          type = types.int;
          default = 90;
          description = mdDoc "The number of days till login auth token is valid.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ryot = rec {
      description = "ryot";
      after = ["network.target" "postgresql.service"];
      requires = ["postgresql.service"];
      wantedBy = ["multi-user.target"];
      path = [cfg.package];

      preStart = ''mkdir -p /usr/share/ryot && chown ${cfg.user}:${cfg.group} /usr/share/ryot'';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${getExe cfg.package}";
        Restart = "always";
        WorkingDirectory = "/usr/share/ryot";

        ReadWritePaths = ["/usr/share/ryot"];

        NoNewPrivileges = true;

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = ["AF_UNIX AF_INET AF_INET6"];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @setuid @swap";

        PassEnvironment = concatStringsSep " " (attrNames environment);
      };

      environment = {
        AUDIO_BOOKS_AUDIBLE_URL = cfg.settings.audio_books.audible.url;
        BOOKS_OPENLIBRARY_URL = cfg.settings.books.openlibrary.url;
        BOOKS_OPENLIBRARY_COVER_IMAGE_URL = cfg.settings.books.openlibrary.cover_image_url;
        BOOKS_OPENLIBRARY_COVER_IMAGE_SIZE = cfg.settings.books.openlibrary.cover_image_size;
        MOVIES_TMDB_URL = cfg.settings.movies.tmdb.url;
        MOVIES_TMDB_ACCESS_TOKEN = cfg.settings.movies.tmdb.access_token;
        SHOWS_TMDB_URL = cfg.settings.shows.tmdb.url;
        SHOWS_TMDB_ACCESS_TOKEN = cfg.settings.shows.tmdb.access_token;
        PODCASTS_LISTENNOTES_URL = cfg.settings.podcasts.listennotes.url;
        PODCASTS_LISTENNOTES_API_TOKEN = cfg.settings.podcasts.listennotes.api_token;
        PODCASTS_LISTENNOTES_USER_AGENT = cfg.settings.podcasts.listennotes.user_agent;
        SCHEDULER_USER_CLEANUP_EVERY = toString cfg.settings.scheduler.user_cleanup_every;
        SCHEDULER_RATE_LIMIT_NUM = toString cfg.settings.scheduler.rate_limit_num;
        VIDEO_GAMES_TWITCH_CLIENT_ID = cfg.settings.video_games.twitch.client_id;
        VIDEO_GAMES_TWITCH_CLIENT_SECRET = cfg.settings.video_games.twitch.client_secret;
        VIDEO_GAMES_TWITCH_ACCESS_TOKEN_URL = cfg.settings.video_games.twitch.access_token_url;
        VIDEO_GAMES_IGDB_URL = cfg.settings.video_games.igdb.url;
        VIDEO_GAMES_IGDB_IMAGE_URL = cfg.settings.video_games.igdb.image_url;
        VIDEO_GAMES_IGDB_IMAGE_SIZE = cfg.settings.video_games.igdb.image_size;
        USERS_ALLOW_CHANGING_USERNAME =
          if cfg.settings.users.allow_changing_username
          then "true"
          else null;
        USERS_TOKEN_VALID_FOR_DAYS = toString cfg.settings.users.token_valid_for_days;
        WEB_CORS_ORIGINS = concatStringsSep "," cfg.cors_urls;

        DATABASE_SCDB_URL = "/usr/share/ryot";
        DATABASE_URL = pgHost cfg.database;
        WEB_INSECURE_COOKIE =
          if cfg.https
          then null
          else "true";

        PORT = toString cfg.port;
      };
    };

    services.postgresql = optionalAttrs cfg.database.createDatabase {
      enable = mkDefault true;

      ensureDatabases = [cfg.database.name];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {"DATABASE ${cfg.database.name}" = "ALL PRIVILEGES";};
        }
      ];
    };

    users.users = mkIf (cfg.user == "ryot") {
      ryot = {
        description = "Ryot Service";
        useDefaultShell = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "ryot") {
      ryot = {};
    };
  };
  meta.maintainers = with maintainers; [nyxkrage];
}
