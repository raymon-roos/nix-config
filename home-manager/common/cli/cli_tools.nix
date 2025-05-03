{
  config,
  lib,
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
      git = true;
      icons = "auto";
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
        "--multi"
        "--prompt='∼ '"
        "--pointer='▶'"
        "--marker='✓'"
        "--select-1"
        "--exit-0"
      ];
      defaultCommand = "fd --hidden ${lib.strings.concatMapStrings (i: "-E '${i}' ") config.programs.fd.ignores}";
      fileWidgetCommand = config.programs.fzf.defaultCommand;
      fileWidgetOptions = [
        "--preview-window=right:50%"
        "--preview='pistol {}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
        "--bind 'ctrl-o:execute(echo {+} | xargs -o nvim)'"
        "--bind 'ctrl-f:preview-half-page-down'"
        "--bind 'ctrl-b:preview-half-page-up'"
      ];
      changeDirWidgetCommand = "${config.programs.fzf.defaultCommand} --type d";
      changeDirWidgetOptions = config.programs.fzf.fileWidgetOptions;
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
