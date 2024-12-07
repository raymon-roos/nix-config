{
  pkgs,
  config,
  ...
} @ inputs: {
  imports = [
    ../common
    ./shell.nix
    ./wayland
  ];

  dev.nix.enable = true;
  dev.nodejs.enable = true;
  dev.php.enable = true;
  dev.rust.enable = true;
  dev.go.enable = true;
  dev.python.enable = false;

  home = {
    stateVersion = "23.11"; # don't change

    username = "ray";

    sessionPath = [
      config.xdg.userDirs.extraConfig.BIN_HOME
    ];

    packages = with pkgs; [
      cmus
      hledger
      hledger-ui
      id3v2
      keychain
      puddletag
      remind
      thunderbird
      vesktop
      vorbis-tools
      wl-clipboard-rs
      ytfzf
    ];
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  programs = {
    git.userEmail = "raymon.roos@hotmail.com";

    rtorrent.enable = true;

    librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "browser.contentblocking.category" = "strict";
        "network.http.referer.XOriginPolicy" = 2; # Referer header lets websites know how you got there. 2 for same-host-only
        "webgl.disabled" = false;

        "browser.startup.homepage" = "https://search.rhscz.eu/";
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "layout.css.devPixelsPerPx" = "0.70"; # shrink ui
      };
      languagePacks = ["en-GB" "nl"];
    };

    zathura = {
      enable = true;
      options = {
        recolor = true;
        sandbox = "strict";
        selection-clipboard = "clipboard";
      };
    };

    mpv = {
      enable = true;
      config = {
        "alang" = "jpn,eng";
        "slang" = "eng";
      };
    };

    yt-dlp = {
      enable = true;
      settings = {
        embed-thumbnail = true;
        embed-subs = true;
        embed-metadata = true;
        sub-langs = "en.*";
        sponsorblock-remove = "sponsor,selfpromo,interaction,intro,outro,preview,music_offtopic";
      };
    };
  };

  xdg.configFile."ytfzf/conf.sh".text = ''
    ytdl_opts='
        -S "res:720,codec,br,ext" \
        --sub-langs "en.*" \
        --embed-subs \
        --write-auto-subs \
        --embed-metadata \
        --sponsorblock-remove=sponsor,selfprommo,interaction,intro,outro,preview,music_offtopic
    '
    url_handler_opts='--speed=1.70 --slang=en'

    thumbnail_viewer=kitty
    show_thumbnails=1
    async_thumbnails=1
    thumbnail_quality=default
    fzf_preview_side=down
  '';

  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
