{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ../common
  ];

  dev.nix.enable = true;
  dev.php.enable = true;
  dev.nodejs.enable = true;

  home = {
    stateVersion = "23.11"; # don't change

    username = "ray";

    sessionPath = [
      config.home.sessionVariables.BIN_HOME
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      vim = "nvim";
    };

    packages = with pkgs; [
      argocd
      calc
      # colima
      difftastic
      wireguard-tools
      inputs.nixpkgs.legacyPackages.${pkgs.system}.neovim-unwrapped
      # neovim-unwrapped
      ltex-ls
      lua51Packages.lua
      lua51Packages.luarocks-nix
      pass
      sd
      yadm
      ytfzf
    ];
  };

  services = {
    # gpg-agent = {
    #   enable = true;
    #   defaultCacheTtl = 600;
    # };
  };

  programs = {
    home-manager.enable = true;

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    neovim = {
      enable = true;
      package = inputs.nixpkgs.legacyPackages.${pkgs.system}.neovim-unwrapped;
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

    git.userEmail = "raymon@fixico.com";

    kitty = {
      enable = true;
      settings = {
        scrollback_lines = 50000;
        enable_audio_bell = false;
        update_check_interval = 0;
        macos_option_as_alt = "both";
        hide_window_decorations = "titlebar-only";
        confirm_os_window_close = 0;
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

    k9s = {
      enable = true;
      settings = {
      };
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };

  stylix.autoEnable = false;
  stylix.targets = {
    bat.enable = true;
    fzf.enable = true;
    gitui.enable = true;
    k9s.enable = true;
    kitty.enable = true;
    yazi.enable = true;
  };
}
