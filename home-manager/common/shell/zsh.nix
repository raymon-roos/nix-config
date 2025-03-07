{config, ...}: {
  home.file = {
    ".zprofile".target = "${config.xdg.configHome}/zsh/.zprofile";
    ".zshrc".target = "${config.xdg.configHome}/zsh/.zshrc";
    ".zshenv".target = "${config.xdg.configHome}/zsh/.zshenv";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      ignoreSpace = true;
      ignoreDups = true;
      share = true;
      ignorePatterns = ["ll" "ls" "y" "pwd" "cd" "fg*" "fg" "exit" "*poweroff*" "reboot" "builtin cd -- *"];
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
