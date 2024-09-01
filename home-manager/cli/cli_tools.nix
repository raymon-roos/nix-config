{
  pkgs,
  lib,
  config,
  ...
}: {
  programs = {
    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob='!*.git/'"
      ];
    };

    fd = {
      enable = true;
      hidden = true;
      ignores = ["*.git/"];
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
        "--smart-group"
        "--git-repos"
      ];
    };

    fzf = let
      # previewer = ''
      #   ([[ -f {} ]] && (bat --style=header,grid --color=always --wrap=auto --terminal-width=-2 {} || cat {})) \
      #     || ([[ -d {} ]] && (eza -T --colour=always --icons --level 2 --git-ignore -I "${builtins.concatStringsSep "|" ignores}" {} || tree -C {} | bat -pp)) \
      #     || echo {} 2> /dev/null | head -200
      # '';
    in {
      enable = true;
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
        # "--preview '${previewer}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
        "--bind 'ctrl-o:execute(echo {+} | xargs -o nvim)'"
      ];
      defaultCommand = "fd --hidden --exclude '*.git/'";
      fileWidgetCommand = config.programs.fzf.defaultCommand;
      changeDirWidgetCommand = "${config.programs.fzf.defaultCommand} --type d";
      historyWidgetOptions = [
        "--preview 'echo {}'"
        "--preview-window up:3:wrap"
      ];
    };

    bat = {
      enable = true;
      config = {
        style = "header,grid";
      };
    };
  };
}
