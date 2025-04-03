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

  common = {
    librewolf.enable = true;
    librewolf-advanced.enable = false;
    rtorrent.enable = true;
    hyprland.enable = true;
    lockscreen.enable = false;
  };
  dev = {
    nix.enable = true;
    nodejs.enable = true;
    php.enable = true;
    rust.enable = true;
    go.enable = false;
    python.enable = false;
  };
  HUazureDevops.enable = true;

  home = {
    stateVersion = "23.11"; # don't change

    username = "ray";

    sessionVariables = {
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    };
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

  wayland.windowManager.hyprland = lib.mkIf config.common.hyprland.enable {
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
