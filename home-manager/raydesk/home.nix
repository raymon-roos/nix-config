{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../common
    ./shell.nix
  ];

  desktop-config.lockscreen.enable = false;
  desktop-config.hyprland.enable = true;
  dev.nix.enable = true;
  dev.nodejs.enable = true;
  dev.php.enable = true;
  dev.rust.enable = true;
  dev.go.enable = false;
  dev.python.enable = false;
  HUazureDevops.enable = true;

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
      inputs.lyrical.packages.${pkgs.system}.default
    ];
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  programs = let
    contact_info = import "${inputs.secrets}/contact_info.nix";
  in {
    git.userEmail = contact_info.personal.address;

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

        # Force hardware acceleration (vaapi), particularly for video decoding
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
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
        "hwdec" = "auto-safe";
        "vo" = "gpu";
        "profile" = "gpu-hq";
        "gpu-context" = "wayland";
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

  wayland.windowManager.hyprland = lib.mkIf config.desktop-config.hyprland.enable {
    settings = {
      monitor = [
        #name,resolution,position,scale,rotation
        "HDMI-A-1,preferred,0x0,auto"
        "DVI-I-1,preferred,auto-right,auto,transform, 3"
        "DP-1,preferred,auto-left,auto,transform, 1"
        "Unknown-1,disable"
      ];
      windowrulev2 = [
        "monitor 2,class:^(cmus)$"
        "monitor 0,initialTitle:^(Mozilla Thunderbird)$"
        "monitor 0,initialClass:^(vesktop)$"
      ];
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

  xresources.path = "${config.xdg.configHome}/X11/Xresources";
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
}
