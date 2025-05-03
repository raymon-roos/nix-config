{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.xdg) configHome;
in {
  programs.nushell = {
    enable = true;

    settings = {
      show_banner = false;
      use_kitty_protocol = config.programs.kitty.enable;
      history.file_format = "sqlite";
      keybindings = lib.mkIf config.programs.fzf.enable [
        # Adapted from https://github.com/junegunn/fzf/issues/4122
        {
          name = "fzf_cd";
          modifier = "alt";
          keycode = "char_c";
          mode = ["emacs" "vi_insert" "vi_normal"];
          event = {
            send = "executehostcommand";
            cmd = ''
              let result = nu -l -i -c $env.FZF_ALT_C_COMMAND | fzf
              cd $result
            '';
          };
        }
        {
          name = "fzf_complete";
          modifier = "control";
          keycode = "char_t";
          mode = ["emacs" "vi_insert"];
          event = {
            send = "executehostcommand";
            cmd = ''
              let result = nu -l -i -c $env.FZF_CTRL_T_COMMAND | fzf
              commandline edit --append $result
              commandline set-cursor --end
            '';
          };
        }
        {
          name = "fzf_history";
          modifier = "control";
          keycode = "char_r";
          mode = ["emacs" "vi_insert" "vi_normal"];
          event = {
            send = "executehostcommand";
            cmd = ''
              let result = open ~/.xdg/config/nushell/history.sqlite3
                | query db "select command_line from history group by command_line order by start_timestamp desc;"
                | get command_line
                | to text
                | fzf --preview "echo {}" --preview-window "up:3:wrap"
              commandline edit --append $result
              commandline set-cursor --end
            '';
          };
        }
      ];
    };

    shellAliases = {
      ls = lib.mkForce "ls -a";
      fg = "job unfreeze";
      jobs = "job list";
    };

    environmentVariables =
      config.home.sessionVariables
      // {
        EDITOR = "nvim";
      };

    extraEnv = ''
      $env.PATH = ($env.Path | prepend "${(
        if pkgs.stdenv.isDarwin
        then config.home.sessionVariables.BIN_HOME
        else config.xdg.userDirs.extraConfig.BIN_HOME
      )}")
    '';

    loginFile.text = lib.mkIf config.common.hyprland.enable ''
      # Logging in on tty1, and Hyprland is not yet running
      if (tty) == "/dev/tty1" and (pgrep "Hyprland" | complete).exit_code != 0 {
        Hyprland
      }
    '';
  };
}
