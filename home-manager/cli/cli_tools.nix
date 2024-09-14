{
  pkgs,
  lib,
  config,
  ...
}: {
  programs = {
    ripgrep.enable = true;

    fd = {
      enable = true;
      hidden = true;
      ignores = [
        ".git/"
        ".xdg/cache"
        ".librewolf/"
        ".thunderbird/"
        ".mozilla/"
        ".nix-defexpr/"
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
        "--smart-group"
        "--git-repos"
      ];
    };

    pistol = {
      enable = true;
      associations = [
        {
          mime = "inode/directory";
          command = builtins.concatStringsSep " " [
            "eza"
            "--almost-all"
            "--tree"
            "--colour=always"
            "--icons"
            "--level 2"
            "--git-ignore"
            "--ignore-glob=${lib.strings.concatMapStrings (i: "|${i}") config.programs.fd.ignores}"
            "%pistol-filename%"
          ];
        }
        {
          mime = "text/*";
          command = "bat --chop-long-lines --paging=never --decorations=never --color=always %pistol-filename%";
        }
      ];
    };

    fzf = {
      enable = true;
      defaultOptions = [
        "--layout=reverse"
        "--info=inline"
        "--height=100%"
        "--preview-window=right:50%"
        "--multi"
        "--prompt='∼ '"
        "--pointer='▶'"
        "--marker='✓'"
        "--select-1 --exit-0"
        "--preview='pistol {}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
        "--bind 'ctrl-o:execute(echo {+} | xargs -o nvim)'"
      ];
      defaultCommand = "fd --hidden ${lib.strings.concatMapStrings (i: "-E '${i}' ") config.programs.fd.ignores}";
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
