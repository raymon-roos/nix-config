{pkgs, ...} @ inputs: let
  user = "ray";
  homeDir = "/home/${user}";
  xdgHome = "${homeDir}/.xdg";
  cacheHome = "${xdgHome}/cache";
  configHome = "${xdgHome}/config";
  dataHome = "${xdgHome}/local/share";
  stateHome = "${xdgHome}/local/state";
  binHome = "${xdgHome}/local/bin";
  srcHome = "${xdgHome}/local/src";
  filesHome = "${homeDir}/files";
in {
  imports = [
    ./features/bash
    ./features/zsh
    ./features/starship
    ./features/cli_tools.nix
    ./wayland/hyprland
  ];

  xdg = {
    dataHome = dataHome;
    cacheHome = cacheHome;
    stateHome = stateHome;
    configHome = configHome;

    userDirs = {
      enable = true;
      createDirectories = true;
      music = "${filesHome}/music";
      videos = "${filesHome}/videos";
      desktop = "${filesHome}/desktop";
      pictures = "${filesHome}/pictures";
      publicShare = "${filesHome}/shared";
      download = "${filesHome}/downloads";
      templates = "${filesHome}/templates";
      documents = "${filesHome}/documents";
      extraConfig = {
        XDG_HOME = xdgHome;
        BIN_HOME = binHome;
        SRC_HOME = srcHome;
        FILES_HOME = filesHome;
        USB_HOME = "${filesHome}/usb";
        PHONE_HOME = "${filesHome}/phone";
        NOTES_HOME = "${filesHome}/zettelkasten";
        FINANCE_HOME = "${filesHome}/finance";
        DOTREMINDERS = "${filesHome}/reminders";
        PASSWORD_STORE_DIR = "${filesHome}/secrets/passwords";
      };
    };
  };

  home = {
    stateVersion = "23.11"; # don't change

    username = user;
    homeDirectory = homeDir;

    sessionVariables = {
      BROWSER = "librewolf";
      TERMINAL = "kitty";
      GDK_SCALE = 0.72;
      MANPAGER = "nvim +Man!";
      MANWIDTH = 90;
      PASSWORD_STORE_CLIP_TIME = 30;
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";

      FLAKE = "/home/ray/.xdg/config/nix";
      ADB_KEYS_PATH = "${configHome}/android";
      CALCHISTFILE = "${stateHome}/calc/calc_history";
      CARGO_HOME = "${dataHome}/cargo";
      COMPOSER_CACHE_DIR = "${cacheHome}/composer";
      COMPOSER_HOME = "${dataHome}/composer";
      DOCKER_CONFIG = "${configHome}/docker";
      GNUPGHOME = "${dataHome}/gnupg";
      GOBIN = binHome;
      GOMODCACHE = "${cacheHome}/go/pkg/mod";
      GOPATH = "$HOME/projects/go";
      IMAPFILTER_HOME = "${configHome}/imapfilter";
      INPUTRC = "${configHome}/readline/inputrc";
      LESSHISTFILE = "${stateHome}/less/lesshst";
      LYNX_CFG_PATH = "${configHome}/lynx/lynx.cfg";
      MYSQL_HISTFILE = "${stateHome}/mysql/mysql_history";
      NODE_REPL_HISTORY = "${stateHome}/node/node_repl_history";
      NOTMUCH_CONFIG = "${configHome}/notmuch/config";
      RUSTUP_HOME = "${dataHome}/rustup";
      TEXMFCONFIG = "${configHome}/texlive/texmf-config";
      TEXMFHOME = "${dataHome}/texmf";
      TEXMFVAR = "${cacheHome}/texlive/texmf-var";
      WGETRC = "${configHome}/wget/wgetrc";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
      npm_config_cache = "${cacheHome}/npm/";
      npm_config_userconfig = "${configHome}/npm/npmrc";
    };

    sessionPath = [
      binHome
    ];

    packages = with pkgs; [
      nix-tree
      sd
      bat
      starship
      cmus
      yadm
      ripdrag
      thunderbird

      alejandra
      nil
      nixd
    ];
  };

  services = {
    # random-background = {
    #   enable = true;
    #   enableXinerama = true;
    #   display = "fill";
    #   imageDirectory = "${config.xdg.userDirs.pictures}/wallpapers";
    #   interval = "10m";
    # };
    mako = {
      enable = true;
      defaultTimeout = 20 * 1000;
      borderRadius = 4;
    };
  };

  programs = {
    home-manager.enable = true;

    neovim = {
      enable = false;
      package = inputs.pkgs-unstable.neovim-unwrapped;
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
      aliases = {
        test = "git log --oneline -20";
      };
      # delta = {
      #   enable = true;
      #   options = {
      #     features = "decorations";
      #   };
      # };
    };
    gitui.enable = true;

    bemenu = {
      enable = true;
      settings = {
        list = 6;
        center = true;
        width-factor = 0.3;
        border = 2;
        border-radius = 6;
        prompt = "";
        binding = "vim";
        vim-esc-exits = true;
        ignorecase = true;
        single-instance = true;
        wrap = true;
      };
    };

    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      shellIntegration.enableZshIntegration = true;
      settings = {
        scrollback_lines = 50000;
        enable_audio_bell = false;
      };
    };

    bottom.enable = true;
    yazi.enable = true;

    zathura.enable = true;

    mpv.enable = true;
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
}
