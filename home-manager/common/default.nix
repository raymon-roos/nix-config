{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cli
    ./dev
    ./directories.nix
    ./environment_variables.nix
    ./shell
  ];

  home.packages = with pkgs; [
    calc
    entr
    neovim-unwrapped
    pass
    ripdrag
    sd
    yadm
  ];

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 600;
    };
  };

  programs = {
    home-manager.enable = true;

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    neovim = {
      enable = false;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
      extraPackages = with pkgs; [
        lua51Packages.lua
        lua51Packages.luarocks-nix
        universal-ctags
        ltex-ls
        alejandra
        nil
        nixd
      ];
    };

    kitty = {
      enable = true;
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
  };
}
