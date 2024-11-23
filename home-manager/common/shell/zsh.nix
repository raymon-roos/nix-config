{
  pkgs,
  config,
  inputs,
  ...
}: let
  stateHome = config.xdg.stateHome;
  configHome = config.xdg.configHome;
in {
  programs.zsh = {
    enable = true;
    dotDir = ".xdg/config/zsh";
    enableCompletion = true;
    defaultKeymap = "emacs";
    history = {
      path = "${stateHome}/zsh/history";
      ignoreSpace = true;
      ignoreDups = true;
      share = true;
      ignorePatterns = ["ls" "y" "pwd" "cd" "fg" "fg %" "exit" "*poweroff*" "reboot" "builtin cd -- *"];
      save = 20000;
      size = 20000;
    };
    autocd = true;
    completionInit = ''
      [ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh

      zstyle cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
      autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
      zstyle ':completion:*' menu select
    '';
    initExtra = ''
      ${builtins.readFile ./zshrc}
      ${builtins.readFile ./functions.sh}
    '';
  };
}
