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
      ignorePatterns = ["ls" "y" "pwd" "cd" "fg %" "exit" "*poweroff*" "reboot" "builtin cd -- *"];
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
    profileExtra = ''
      # autostart compositor of choice when logging in on tty1
      if [[ "$XDG_VTNR" == 1 ]]; then
          hyprland
      fi
    '';
    initExtra = ''
      ${builtins.readFile ./zshrc}
      ${builtins.readFile ./functions.sh}
      # hack to fix dynamically linked binaries for traditional distros
      NIX_LD="$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')"
      export NIX_LD
    '';
  };
}
