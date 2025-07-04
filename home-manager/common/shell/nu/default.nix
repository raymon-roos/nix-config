{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = config.programs.nushell.plugins;
  programs.nushell = {
    enable = true;

    plugins = with pkgs.nushellPlugins; [formats gstat polars query skim];

    settings = {
      show_banner = false;
      use_kitty_protocol = config.programs.kitty.enable;
      history.file_format = "sqlite";
      history.max_size = 500000;
      table.mode = "compact";
      table.index_mode = "auto";
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
              let result = nu --no-config-file --no-std-lib  -c $env.FZF_ALT_C_COMMAND | fzf
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
              let result = nu --no-config-file --no-std-lib -c $env.FZF_CTRL_T_COMMAND
                | fzf --scheme=path --multi
                | lines
                | str join ' '
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
                | str join (char -i 0)
                | fzf --read0 --query=(commandline) --scheme=history --bind="ctrl-r:toggle-sort" --preview-window="up:4:wrap" --preview='"{r}" | nu-highlight'
              commandline edit --replace $result
              commandline set-cursor --end
            '';
          };
        }
      ];
    };

    shellAliases = {
      ls = lib.mkForce "ls -a";
      ll = "eza -Al --group-directories-first --smart-group";
      fg = "job unfreeze";
      jobs = "job list";
    };

    environmentVariables =
      config.home.sessionVariables
      // {
        EDITOR = "nvim";
      };

    extraEnv = ''
      $env.PATH = ($env.Path | prepend "${config.xdg.userDirs.extraConfig.BIN_HOME}")
    '';

    extraConfig = builtins.readFile ./commands.nu;
  };
}
