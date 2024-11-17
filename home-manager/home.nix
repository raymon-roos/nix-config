{
  pkgs,
  config,
  ...
} @ inputs: {
  imports = [
    ./directories.nix
    ./environment_variables.nix
    ./cli
    ./shell
    ./wayland
    ./dev
  ];

  home = {
    stateVersion = "23.11"; # don't change

    username = "ray";

    sessionPath = [
      config.xdg.userDirs.extraConfig.BIN_HOME
    ];

    packages = with pkgs; [
      yadm
      sd
      ripdrag
      entr
      calc
      cmus
      ytfzf

      universal-ctags

      thunderbird
      remind
      hledger
      hledger-ui

      pass

      (
        inputs.plover-flake.packages.${pkgs.system}.plover.with-plugins (
          ps:
            with ps; [
              # plover-console-ui
            ]
        )
      )

      neovim-unwrapped
      lua51Packages.lua
      lua51Packages.luarocks-nix
      ltex-ls
    ];
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 600;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

  programs = {
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    home-manager.enable = true;

    neovim = {
      enable = false;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
      extraPackages = with pkgs; [
        alejandra
        nil
        nixd
      ];
    };

    git = {
      enable = true;
      userEmail = "raymon.roos@hotmail.com";
      userName = "Raymon Roos";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
      delta = {
        enable = true;
        options = {
          features = "decorations";
        };
      };
    };
    gitui.enable = true;

    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      shellIntegration.enableZshIntegration = true;
      settings = {
        scrollback_lines = 50000;
        enable_audio_bell = false;
        update_check_interval = 0;
      };
      keybindings = {
        "kitty_mod+t" = "new_tab_with_cwd";
        "kitty_mod+enter" = "launch --type=os-window --cwd=current";
      };
    };

    rtorrent.enable = true;

    bottom = {
      enable = true;
      settings = {
        flags = {
          dot_marker = true;
          regex = true;
          tree = true;
          enable_cache_memory = true;
          disable_gpu = false;
        };
      };
    };

    jq.enable = true;

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
