{ pkgs, config, osConfig, lib, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };
    initExtra = ''
      PROMPT='%n@%m %~ %# '
    '';
  };

  programs.emacs = {
    enable = true;
    package = if osConfig.graphical then pkgs.emacsGit else pkgs.emacsGit-nox;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
      epkgs.auctex
      (pkgs.callPackage ./spectre-el.nix {})
    ];
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = if osConfig.graphical then "gtk2" else "curses";
    enableSshSupport = true;
    sshKeys = [ "64AB8617FA4EC63E93A4E1A94AE9B14AF64A86C6" "C54678A60A531F2144EC2391CF888696261ED167" ];
  };

  programs.firefox = {
    enable = osConfig.graphical;
    package = (pkgs.firefox-devedition-bin.override { wmClass = "firefox-aurora"; });
    profiles.default = {};
    profiles.dev-edition-default = {
      name = "dev-edition-default";
      id = 1;
      extensions =
          with pkgs.nur.repos.rycee.firefox-addons;
          with pkgs.nur.repos.sanctureplicum.firefox-addons;
        [
            add-custom-search-engine
            clearurls
            decentraleyes
            duplicate-tab-shortcut
            multi-account-containers
            istilldontcareaboutcookies
            masterpassword-firefox
            header-editor
            privacy-badger
            privacy-redirect
            amp2html
            tab-stash
            ublock-origin
            vimium
      ];
      settings = {
        "app.normandy.api_url" = "";
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.update.auto" = false;
        "beacon.enabled" = false;
        "breakpad.reportURL" = "";
        "browser.aboutConfig.showWarning" = false;
        "browser.cache.offline.enable" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.disableResetPrompt" = true;
        "browser.formfill.enable" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.safebrowsing.appRepURL" = "";
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.selfsupport.url" = "";
        "browser.send_pings" = false;
        "browser.sessionstore.privacy_level" = 0;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.tabs.firefox-view" = false;
        "browser.urlbar.groupLabels.enabled" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.urlbar.trimURLs" = false;
        "browser.warnOnQuitShortcut" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "device.sensors.ambientLight.enabled" = false;
        "device.sensors.enabled" = false;
        "device.sensors.motion.enabled" = false;
        "device.sensors.orientation.enabled" = false;
        "device.sensors.proximity.enabled" = false;
        "dom.battery.enabled" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.webaudio.enabled" = false;
        "experiments.activeExperiment" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "experiments.supported" = false;
        "extensions.CanvasBlocker@kkapsner.de.whiteList" = "";
        "extensions.ClearURLs@kevinr.whiteList" = "";
        "extensions.Decentraleyes@ThomasRientjes.whiteList" = "";
        "extensions.FirefoxMulti-AccountContainers@mozilla.whiteList" = "";
        "extensions.autoDisableScopes" = 14;
        "extensions.getAddons.cache.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.api_url" = "";
        "extensions.shield-recipe-client.enabled" = false;
        "extensions.webservice.discoverURL" = "";
        "media.autoplay.default" = 1;
        "media.autoplay.enabled" = false;
        "media.eme.enabled" = false;
        "media.gmp-widevinecdm.enabled" = false;
        "media.navigator.enabled" = false;
        "media.peerconnection.enabled" = false;
        "media.video_stats.enabled" = false;
        "network.IDN_show_punycode" = true;
        "network.allow-experiments" = false;
        "network.captive-portal-service.enabled" = true;
        "network.cookie.cookieBehavior" = 1;
        "network.dns.disablePrefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.http.referer.spoofSource" = true;
        "network.http.speculative-parallel-limit" = 0;
        "network.predictor.enable-prefetch" = false;
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;
        "pdfjs.enableScripting" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = 1;
        "privacy.query_stripping" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.usercontext.about_newtab_segregation.enabled" = true;
        "security.ssl.disable_session_identifiers" = true;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
        "signon.autofillForms" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.cachedClientID" = "";
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "webgl.renderer-string-override" = " ";
        "webgl.vendor-string-override" = " ";
      };
    };
  };

  services.lorri.enable = true;

  home.packages = with pkgs; [
    (ripgrep.override { withPCRE2 = true; })
    direnv
    dogdns
    duf
    exa
    fd
    jq
    mcfly
    pinentry-curses
    unzip
    yq
    wezterm


    # Rust
    cargo
    gcc
    llvmPackages_latest.lld
    llvmPackages_latest.llvm
    rustc

    # JS
    nodejs
    nodePackages.npm

    # Music
    mpc-cli

    # language-servers
    rust-analyzer
  ] ++ lib.lists.optionals osConfig.graphical [
    (discord.override { withOpenASAR = true; })
    catppuccin-gtk
    dconf
    gparted
    numberstation
    pavucontrol
    pinentry-gtk2
    recursive
    wireplumber
    # Local
    (callPackage ./areon-pro {})
    (callPackage ./rec-mono-nyx.nix {})

    gnomeExtensions.color-picker
    gnomeExtensions.just-perfection
    gnomeExtensions.unite
  ];
}
