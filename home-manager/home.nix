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
  ];

  home = {
    stateVersion = "23.11"; # don't change

    username = "ray";

    sessionPath = [
      config.xdg.userDirs.extraConfig.BIN_HOME
    ];

    packages = with pkgs; [
      yadm
      starship
      sd
      ripdrag
      calc
      cmus
      ytfzf


      thunderbird
      remind

      pass

      neovim-unwrapped
      nix-tree
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

    gpg-agent = {
      enable = true;
      defaultCacheTtl = 600;
      pinentryPackage = pkgs.pinentry-gtk2;
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
