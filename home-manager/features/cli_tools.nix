{
  pkgs,
  lib,
  config,
  ...
}: let
  ignores = [
    ".xdg/cache/*"
    ".xdg/local/share/yadm/repo.git/*"
    ".nix-*"
    ".librewolf/*"
    ".mozilla/*"
    ".thunderbird/*"
    ".git"
    "vendor/*"
    "node_modules/*"
  ];
  ignoreArgs = lib.map (x: "-I ${x} ") ignores;
in {
  programs = {
    ripgrep = {
      enable = true;
      arguments =
        [
          "--smart-case"
          "--hidden"
        ]
        ++ lib.map (x: "--glob=!${x}") ignores;
    };

    fd = {
      enable = true;
      hidden = true;
      inherit ignores;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions =
        [
          "--all"
          "--long"
          "--group-directories-first"
          "--smart-group"
          "--git-repos"
        ]
        ++ ignoreArgs;
    };
    bash.shellAliases = {
      ls = "eza --long";
    };
    zsh.shellAliases = {
      ls = "eza --long";
    };

    fzf = let
      previewer = ''
        ([[ -f {} ]] && (bat --style=header,grid --color=always --wrap=auto --terminal-width=-2 {} || cat {})) \
          || ([[ -d {} ]] && (eza --git-ignore --level 3 -T --colour=always --icons ${lib.concatStrings ignoreArgs} {} || tree ${lib.concatStrings ignoreArgs} -C {} | bat -pp)) \
          || echo {} 2> /dev/null | head -200
      '';
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
        "--preview '${previewer}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
        "--bind 'ctrl-o:execute(echo {+} | xargs -o nvim)'"
      ];
      defaultCommand = "fd --hidden ${lib.concatMapStrings (x: "--exclude ${x} ") ignores}";
      # fileWidgetCommand = config.programs.fzf.defaultCommand + " --type f";
      changeDirWidgetCommand = "${config.programs.fzf.defaultCommand} --type d";
      historyWidgetOptions = [
        "--preview 'echo {}'"
        "--preview-window up:3:wrap"
      ];
    };
  };
}
