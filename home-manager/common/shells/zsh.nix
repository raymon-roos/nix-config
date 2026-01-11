{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.xdg) configHome stateHome;
in
  with lib; {
    options.common.shell.zsh.enable = mkEnableOption "zsh shell & configuration";

    config = mkIf config.common.shell.zsh.enable {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        defaultKeymap = "emacs";
        history = {
          path = "${stateHome}/zsh/history";
          ignoreSpace = true;
          ignoreDups = true;
          share = true;
          ignorePatterns = ["ll" "ls" "y" "pwd" "cd" "fg*" "exit" "systemctl sleep" "*poweroff*" "reboot" "builtin cd -- *"];
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
        initContent = ''
          ${builtins.readFile ./zshrc}
          ${builtins.readFile ./functions.sh}
        '';
      };

      home.file = {
        # ".zprofile".target = "${config.xdg.configHome}/zsh/.zprofile";
        "${config.programs.zsh.dotDir}/.zshrc".target = "${configHome}/zsh/.zshrc";
        "${config.programs.zsh.dotDir}/.zshenv".target = "${configHome}/zsh/.zshenv";
      };
    };
  }
