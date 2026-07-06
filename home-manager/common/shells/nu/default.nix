{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.common.shell.nu.enable = mkEnableOption "Nu shell & configuration";

  config = mkIf config.common.shell.nu.enable {
    home.packages = config.programs.nushell.plugins;
    programs = {
      nushell = {
        enable = true;

        plugins = with pkgs.nushellPlugins; [
          formats
          gstat
          polars
          query
          skim
        ];

        settings = {
          show_banner = false;
          use_kitty_protocol = config.programs.kitty.enable;

          history = {
            file_format = "sqlite";
            max_size = 1000000;
            path = "${config.xdg.stateHome}/nushell/history.sqlite3";
          };

          table = {
            mode = "compact";
            index_mode = "auto";
            header_on_separator = true;
          };

          # datetime_format.normal = "%F %T";
          # datetime_format.table = "%F %T";

          keybindings =
            [
              {
                name = "copy_commandline";
                modifier = "alt_shift";
                keycode = "char_c";
                mode = ["emacs" "vi_insert" "vi_normal"];
                event = {
                  send = "executehostcommand";
                  cmd = ''
                    commandline | wl-clip -selection clipboard
                  '';
                };
              }
            ]
            ++ (lib.optionals config.programs.fzf.enable [
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
                    let result = open $nu.history-path
                    | query db "select command_line from history group by command_line order by id desc;"
                    | get command_line
                    | str join (char -i 0)
                    | fzf --read0 --query=(commandline) --scheme=history --bind="ctrl-r:toggle-sort" --preview-window="up:4:wrap" --preview="r#'{r}'# | nu-highlight"
                    commandline edit --replace $result
                    commandline set-cursor --end
                  '';
                };
              }
            ]);
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

      carapace.enable = config.programs.nushell.enable;
    };
  };
}
