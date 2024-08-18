{
  pkgs,
  config,
  ...
}: let
  cacheHome = config.xdg.cacheHome;
  stateHome = config.xdg.stateHome;
in {
  programs = {
    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob=!.git/*"
        "--glob=!vendor/*"
        "--glob=!node_modules/*"
        "--glob=!vendor/*"
        "--glob=!${cacheHome}"
        "--glob=!${stateHome}"
        "--glob=!~/.nix-defexpr/"
        "--glob=!~/.nix-profile/"
        "--glob=!~/.nix-channels/"
      ];
    };

    fd = {
      enable = true;
      hidden = true;
      ignores = [
        "${cacheHome}"
        "${stateHome}"
        ".git/"
        "vendor/"
        "node_modules/"
        "~/.nix-defexpr/"
        "~/.nix-profile/"
        "~/.nix-channels/"
      ];
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions = [
        "--all"
        "--group-directories-first"
        "--group"
      ];
    };
    bash.shellAliases = {
      ls = "eza --long";
    };
    zsh.shellAliases = {
      ls = "eza --long";
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--layout=reverse"
        "--info=inline"
        "--height=100%"
        "--preview-window=right:60%"
        "--multi"
        "--prompt='∼ '"
        "--pointer='▶'"
        "--marker='✓'"
        "--select-1 --exit-0"
        "--preview '([[ -f {} ]] && (bat --style=header,grid --color=always --wrap=auto --terminal-width=-2 {} || cat {})) || ([[ -d {} ]] && (tree -I vendor -I node_modules -I cache -I state -C {} | less)) || echo {} 2> /dev/null | head -200'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
        "--bind 'ctrl-o:execute(echo {+} | xargs -o nvim)'"
      ];
      historyWidgetOptions = [
        "--preview 'echo {}' --preview-window up:3:wrap"
      ];
    };
  };
}
