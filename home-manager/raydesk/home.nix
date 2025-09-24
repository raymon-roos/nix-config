{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../common
    ./scripts
  ];

  common = {
    librewolf.enable = true;
    librewolf-advanced.enable = true;
    rtorrent.enable = true;
    wayland.enable = true;
    hyprland.enable = true;
    river.enable = false;
    mango.enable = false;
    lockscreen.enable = false;
    email = {
      enable = true;
      accounts = [
        {
          accountName = "personal";
          flavor = "outlook.office365.com";
          primary = true;
        }
        {
          accountName = "fixico";
          flavor = "gmail.com";
        }
        {
          accountName = "gaming";
          flavor = "outlook.office365.com";
        }
        {
          accountName = "gmail";
          flavor = "gmail.com";
        }
      ];
    };
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

    sessionVariables = {
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      LEDGER_FILE = "${config.xdg.userDirs.extraConfig.FINANCE_HOME}/hledger/hledger.journal";
    };

    packages = with pkgs; [
      calibre
      cmus
      hledger
      hledger-ui
      id3v2
      inputs.lyrical.packages.${pkgs.system}.default
      puddletag
      vorbis-tools
      ytfzf
    ];

    shellAliases = {
      hledger-ui = "hledger-ui --theme=terminal";
    };
  };

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

  wayland.windowManager = {
    hyprland = lib.mkIf config.common.hyprland.enable {
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
          "monitor 0,initialClass:^(vesktop)$"
        ];
      };
    };
    river = lib.mkIf config.common.river.enable {
      settings = {
        spawn = [
          ''
            'wlr-randr \
               --output DP-1 --preferred --left-of HDMI-A-1 --transform 90 \
               --output DVI-I-1 --preferred --right-of HDMI-A-1 --transform 270'
          ''
        ];
        rule-add = {
          "-app-id" = {
            "cmus" = "output DP-1";
            "vesktop" = "output DVI-I-1";
          };
        };
      };
    };
  };

  xdg.configFile."ytfzf/conf.sh".text = let
    key_value = lib.generators.toKeyValue {listsAsDuplicateKeys = true;};
    cli_shell = lib.cli.toGNUCommandLineShell {optionValueSeparator = "=";};
  in
    key_value {
      ytdl_opts = ''"${cli_shell (
          {format-sort = "res:720,codec,br,ext";}
          // config.programs.yt-dlp.settings
        )}"'';

      url_handler_opts = ''"${cli_shell {
          speed = 1.70;
          slang = "en";
        }}"'';
    };
}
