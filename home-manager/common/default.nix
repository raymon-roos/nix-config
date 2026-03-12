{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cli
    ./dev
    ./directories.nix
    ./environment_variables.nix
    ./shells
    ./scripts
    ./wayland
    ./librewolf
    ./hu_azure_devops.nix
    ./mail
  ];

  home = {
    username = "ray";

    packages = with pkgs;
      [
        calc
        entr
        ripdrag
        sd
        yadm
        zip
        unzip
        neovim
        remind
        typst
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        keychain
        wl-clipboard-rs
        simple-mtpfs
        inotify-tools
        pwmenu
      ];

    file = lib.optionalAttrs pkgs.stdenv.isLinux {
      # Don't clutter my $HOME with backwards-compatibility
      ".icons/default/index.theme".enable = false;
      ".icons/${config.stylix.cursor.name}".enable = false;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      lib.optionalAttrs config.programs.zathura.enable {
        "application/pdf" = ["org.pwmt.zathura.desktop"];
      }
      // lib.optionalAttrs config.programs.vesktop.enable {
        "x-scheme-handler/discord" = ["vesktop.desktop"];
      };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 600;
      pinentry.package = pkgs.pinentry-qt;
    };
  };

  programs = {
    ssh = {
      enable = true;
      matchBlocks."*" = {
        forwardAgent = false; # Reuse your local authentication agent on matching hosts you ssh into.
        addKeysToAgent = "no"; # Adds keys to agent as they're used
        controlMaster = "no"; # Can multiplex several open sessions over one connection, skips initial handshake when starting connections
        controlPersist = "no"; # Don't keep controlMaster alive after closing its session
      };
    };

    nh = {
      enable = true;
      flake = "${config.xdg.configHome}/nix";
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR =
          config.home.homeDirectory + "/files/secrets/passwords";
        PASSWORD_STORE_CLIP_TIME = "30";
      };
    };

    neovim = {
      enable = false;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
    };

    kitty = {
      enable = true;
      settings = {
        scrollback_lines = 50000;
        enable_audio_bell = false;
        update_check_interval = 0;
        cursor_trail = 4;
        cursor_trail_decay = "0.1 0.2";
        cursor_trail_start_threshold = 4;
      };
      keybindings = {
        "kitty_mod+t" = "new_tab_with_cwd";
        "kitty_mod+enter" = "launch --type=os-window --cwd=current";
        "kitty_mod+y>f" = "kitten hints --type=path --program @";
        "kitty_mod+y>e" = "kitten hints --type=hyperlink --program @";
        "kitty_mod+y>u" = "kitten hints --type=url --program @";
        "kitty_mod+y>w" = "kitten hints --type=word --program @";
        "kitty_mod+y>l" = "kitten hints --type=line --program @";
      };
    };

    bottom = {
      enable = true;
      settings = {
        flags = {
          dot_marker = true;
          regex = true;
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
        selection-clipboard = "clipboard";
      };
    };

    vesktop = {
      enable = true;
      settings = {
        discordBranch = "stable";
        appBadge = false;
        arRPC = false;
        checkUpdates = false;
        autoUpdate = false;
        autoUpdateNotification = false;
        customTitleBar = false;
        disableMinSize = true;
        tray = false;
        minimizeToTray = false;
        openLinksWithElectron = false;
        enableSplashScreen = false;
        staticTitle = true;
        hardwareAcceleration = true;
        spellCheckLanguages = ["en" "en-GB" "nl"];
      };
      vencord.useSystem = true;
      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        useQuickCss = true;
        disableMinSize = true;
        plugins = {
          Settings.enabled = true;
          NoTrack.enabled = true;
          WebContextMenus.enabled = true;
          DisableDeepLinks.enabled = true;
          WebScreenShareFixes.enabled = true;
          CrashHandler.enabled = true;
          WebKeybinds.enabled = true;
          NoTypingAnimation.enabled = true;
          VolumeBooster.enabled = true;
        };
      };
    };

    pandoc = {
      enable = true;
      defaults = {
        pdf-engine = "typst";
      };
    };
  };

  stylix.targets = {
    gtk.flatpakSupport.enable = false;
    bemenu.fontSize = lib.mkDefault 8;
    librewolf.profileNames = ["default"];
    neovim.enable = false;
    kde.enable = false; # not compatible with nushell + nvim (?)
  };

  xresources.path = lib.mkIf pkgs.stdenv.isLinux "${config.xdg.configHome}/X11/Xresources";
  gtk.gtk2.configLocation = lib.mkIf pkgs.stdenv.isLinux "${config.xdg.configHome}/gtk-2.0/gtkrc";

  gtk = {
    gtk3.bookmarks = map (x: "file://${config.home.homeDirectory}/${x}") ["scratch" "projects" "files"];
  };
}
