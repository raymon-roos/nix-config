{
  pkgs,
  config,
  ...
}: {
  programs.bash = {
    enable = false;
    enableCompletion = true;
    historyControl = [ "erasedups" ];
    historyIgnore = [ "ls" "y" "pwd" "cd" "fg %" "exit" "sudo poweroff*" "builtin cd -- *" ];
    historyFile = "${config.xdg.stateHome}/bash/history";
    profileExtra = ''
      # autostart compositor of choice when logging in on tty1
      if [[ "$XDG_VTNR" == 1 ]]; then
          hyprland
      fi
    '';
    initExtra = ''
      # hack to fix dynamically linked binaries for traditional distros
      NIX_LD="$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')"
      export NIX_LD
    '';
    bashrcExtra = builtins.readFile ./functions.sh;
  };

  programs.readline = {
    enable = config.programs.bash.enable;
    includeSystemConfig = true;
    extraConfig = ''
      set bell-style none
      set enable-bracketed-paste
      set colored-stats On
      set completion-prefix-display-length 5
      set show-all-if-ambiguous On
      set show-all-if-unmodified On
    '';
  };

  home.sessionVariables.INPUTRC = "${config.xdg.configHome}/readline/inputrc";
}
