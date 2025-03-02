{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.common.librewolf.enable = mkEnableOption ''
    firefox-based browser optimized for privacy
  '';

  options.common.librewolf-advanced.enable = mkEnableOption ''
    fully declarative browser profiles configuration. Must first
    remove existing browser profile. The goal is to have maximum
    cookie isolation, across study, work, and personal browser
    profiles, each with slightly different auto containers.
  '';

  config = mkIf config.common.librewolf.enable {
    programs.librewolf = {
      enable = true;
      settings = mkIf (!config.common.librewolf-advanced.enable) {
        "identity.fxaccounts.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "browser.contentblocking.category" = "strict";
        "network.http.referer.XOriginPolicy" = 2; # Referer header lets websites know how you got there. 2 for same-host-only
        "webgl.disabled" = false;

        # "browser.startup.homepage" = "${config.programs.librewolf.policies.Homepage.url}";
        # "browser.urlbar.suggest.engines" = false;
        # "browser.urlbar.suggest.history" = false;
        # "browser.urlbar.suggest.openpage" = false;
        # "browser.urlbar.suggest.recentsearches" = false;
        "layout.css.devPixelsPerPx" = "0.60"; # shrink ui

        # Force hardware acceleration (vaapi), particularly for video decoding
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
      };

      languagePacks = ["en-GB" "nl"];

      policies = mkIf config.common.librewolf-advanced.enable {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        Cookies = {
          Behavior = "reject-tracker-and-partition-foreign";
          BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
        };
        DisableFirfoxAccounts = false; # enable account sync for bookmarks
        DisableFirfoxStudies = true;
        DisableFormHistory = true;
        DisablePocket = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "never";
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        DNSOverHTTPS = {
          ProviderURL = "https://base.dns.mullvad.net/dns-query";
          Fallback = false;
        };
        EnableTrackingProtection = true;

        ExtensionSettings = let
          mkExt = name: uuid:
            nameValuePair uuid {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
            };
        in
          listToAttrs [
            # Best open source blocker
            (mkExt "ublock-origin" "uBlock0@raymondhill.net")
            # Prevent network requests to common CDNs
            (mkExt "localcdn-fork-of-decentraleyes" "{b86e4813-687a-43e6-ab65-0bde4ab75758}")
            # Dark mode everywhere
            (mkExt "darkreader" "addon@darkreader.org")
            # Make youtube bearable
            (mkExt "sponsorblock" "sponsorBlocker@ajay.app")
          ]
          // {
            # Vim emulation in the browser
            "tridactyl.vim.betas@cmcaine.co.uk" = {
              installation_mode = "force_installed";
              install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
            };
          };

        ExtensionUpdate = true;
        FirefoxHome = {
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = false;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = false;
        };
        HardwareAcceleration = true;
        Homepage = {
          url = "https://search.rhscz.eu/";
          StartPage = "homepage";
        };
        HttpsOnlyMode = "enabled";
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        PopupBlocking.default = true;
        PromptForDownloadLocation = true;
        SearchSuggestEnabled = false;
        SanitizeOnShutdown = {
          Cache = true;
          Cookies = true;
          Downloads = true;
          FormData = true;
          History = true;
          Sessions = true;
          SiteSettings = true;
          OfflineApps = true;
        };
        SearchEngines = {
          Remove = ["Amazon.com" "Bing" "Google" "Wikipedia"];
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          FirefoxLabs = false;
          Locked = false;
        };
      };

      profiles = mkIf config.common.librewolf-advanced.enable {
        default = {
          isDefault = true;

          extensions = [];

          search = {
            # home-manager will always fail to rebuild with this off due to
            # a file conflict. Will overwrite existing search configurations.
            force = true;
            default = "searx";
            privateDefault = "searx";
            engines = {
              "searx" = {
                urls = [{template = "https://search.rhscz.eu/search?q={searchTerms}";}];
                definedAliases = ["s"];
              };
              "ddglite" = {
                urls = [{template = "https://lite.duckduckgo.com/lite/";}];
                definedAliases = ["ddg"];
              };
              "mynixos" = {
                urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
                definedAliases = ["my"];
              };
              "github" = {
                urls = [{template = "https://github.com/search?q={searchTerms}";}];
                definedAliases = ["gh"];
              };
              "discogs" = {
                urls = [{template = "https://www.discogs.com/search?q={searchTerms}";}];
                definedAliases = ["dis"];
              };
            };
            order = ["searx" "ddglite" "github" "mynixos" "discogs"];
          };

          containers = {
            fixico = {
              id = 0;
              color = "turquoise";
            };
            bitacademy = {
              id = 1;
              color = "green";
            };
            discord = {
              id = 2;
              color = "purple";
            };
            github = {
              id = 3;
              color = "blue";
            };
            hu = {
              id = 4;
              color = "turquoise";
            };
            banking = {
              id = 5;
              color = "green";
            };
            google = {
              id = 6;
              color = "red";
            };
            attlassian = {
              id = 7;
              color = "red";
            };
            private = {
              id = 8;
              color = "toolbar";
            };
            shopping = {
              id = 9;
              color = "purple";
            };
            microsoft = {
              id = 10;
              color = "purple";
            };
          };
          # |> mapAttrs (name: value: value // {icon = "circle";});

          settings = {
            "identity.fxaccounts.enabled" = true;
            "privacy.donottrackheader.enabled" = true;
            "privacy.resistFingerprinting" = true;
            "privacy.clearOnShutdown.history" = true;
            "privacy.clearOnShutdown.downloads" = true;
            "browser.contentblocking.category" = "strict";
            "network.http.referer.XOriginPolicy" = 2; # Referer header lets websites know how you got there. 2 for same-host-only
            "webgl.disabled" = false;

            # "browser.startup.homepage" = "${config.programs.librewolf.policies.Homepage.url}";
            # "browser.urlbar.suggest.engines" = false;
            # "browser.urlbar.suggest.history" = false;
            # "browser.urlbar.suggest.openpage" = false;
            # "browser.urlbar.suggest.recentsearches" = false;
            "layout.css.devPixelsPerPx" = "0.60"; # shrink ui

            # Force hardware acceleration (vaapi), particularly for video decoding
            "media.ffmpeg.vaapi.enabled" = true;
            "media.hardware-video-decoding.force-enabled" = true;
          };
        };
        school = {id = 1;};
        work = {id = 2;};
      };
    };

    home.packages =
      lib.optional
      (config.desktop-config.hyprland.enable && config.common.librewolf.enable && config.common.librewolf-advanced.enable)
      (pkgs.writeShellScriptBin "browser_profile_select.sh" ''
        # Launch browser with selected profile
        librewolf -P "$(rg 'Name=' ~/.librewolf/profiles.ini | awk -F '=' '{print $2}' | bemenu)"
      '');
  };
}
