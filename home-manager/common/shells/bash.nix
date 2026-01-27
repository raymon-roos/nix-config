{
  config,
  lib,
  ...
}: let
  inherit (config.xdg) configHome;
in
  with lib; {
    options.common.shell.bash.enable = mkEnableOption "Bash shell & configuration";

    config = mkIf config.common.shell.bash.enable {
      programs.bash = {
        enable = true;
        enableCompletion = true;
        historyFile = "${config.xdg.stateHome}/bash/history";
        historyControl = ["erasedups"];
        historyIgnore = ["ls" "y" "pwd" "cd" "fg" "fg %" "exit" "systemctl sleep" "*poweroff*" "reboot" "builtin cd -- *"];
        bashrcExtra = builtins.readFile ./functions.sh;
        profileExtra = ''
          [[ -f "$XDG_CONFIG_HOME/bash/bash_profile" ]] && . "$XDG_CONFIG_HOME/bash/bash_profile"

          [[ -f "$XDG_CONFIG_HOME/bash/bashrc" ]] && . "$XDG_CONFIG_HOME/bash/bashrc"
        '';
      };

      home.file = {
        ".bash_profile".target = "${configHome}/bash/bash_profile";
        ".bashrc".target = "${configHome}/bash/bashrc";
        ".profile".target = "${configHome}/bash/profile";
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

      home.sessionVariables.INPUTRC = lib.mkForce "${config.xdg.configHome}/readline/inputrc";
      xdg.configFile."inputrc".target = "${configHome}/readline/inputrc";
    };
  }
