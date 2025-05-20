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
    ./shell
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
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        keychain
        vesktop
        thunderbird
        wl-clipboard-rs
        slurp
        grim
        simple-mtpfs
      ];

    file = lib.optionalAttrs pkgs.stdenv.isLinux {
      # Don't clutter my $HOME with backwards-compatibility
      ".icons/default/index.theme".enable = false;
      ".icons/${config.stylix.cursor.name}".enable = false;
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 600;
    };
  };

  programs = {
    ssh.enable = true;

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
          config.home.homeDirectory
          + (
            if pkgs.stdenv.isDarwin
            then ""
            else "/files"
          )
          + "/secrets/passwords";
        PASSWORD_STORE_CLIP_TIME = "30";
      };
    };

    neovim = {
      enable = true;
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
  };

  stylix.targets = {
    gtk.flatpakSupport.enable = false;
    bemenu.fontSize = lib.mkDefault 8;
    librewolf.profileNames = ["default"];
    neovim.enable = false;
  };

  xresources.path = lib.mkIf pkgs.stdenv.isLinux "${config.xdg.configHome}/X11/Xresources";
  gtk.gtk2.configLocation = lib.mkIf pkgs.stdenv.isLinux "${config.xdg.configHome}/gtk-2.0/gtkrc";

  gtk = {
    gtk3.bookmarks = map (x: "file://${config.home.homeDirectory}/${x}") ["scratch" "projects" "files"];
  };
}
