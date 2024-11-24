{config, ...}: {
  programs.bash = {
    enable = false;
    enableCompletion = true;
    historyFile = "${config.xdg.stateHome}/bash/history";
    historyControl = ["erasedups"];
    historyIgnore = ["ls" "y" "pwd" "cd" "fg" "fg %" "exit" "*poweroff*" "reboot" "builtin cd -- *"];
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
