{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
    keymap = let
      inherit (config.xdg) configHome userDirs;
    in {
      mgr.prepend_keymap = [
        {
          run = "quit --no-cwd-file";
          on = ["q"];
        }
        {
          run = "quit";
          on = ["<C-g>"];
        }
        {
          run = "follow";
          on = ["F"];
        }
        {
          run = "cd /";
          on = ["g" "/"];
        }
        {
          run = "cd ${configHome}";
          on = ["g" "c"];
        }
        {
          run = "cd ${userDirs.download}";
          on = ["g" "d"];
        }
        {
          run = "cd ${userDirs.documents}";
          on = ["g" "D"];
        }
        {
          run = "cd ${userDirs.music}";
          on = ["g" "m"];
        }
        {
          run = "cd ${userDirs.extraConfig.FILES_HOME}";
          on = ["g" "f"];
        }
        {
          run = "cd ${userDirs.extraConfig.PROJECTS_HOME}";
          on = ["g" "P"];
        }
        {
          run = "cd ${userDirs.extraConfig.PROJECTS_HOME}/personal";
          on = ["g" "p"];
        }
        {
          run = "cd ${userDirs.extraConfig.PROJECTS_HOME}/open-ict";
          on = ["g" "o"];
        }
        {
          run = "cd ${userDirs.extraConfig.FINANCE_HOME}";
          on = ["g" "F"];
        }
        {
          run = ''
            shell -- ripdrag -nx "$@"
          '';
          on = ["<C-n>"];
        }
      ];
    };
  };

  xdg = lib.mkIf pkgs.stdenv.isLinux {
    configFile."xdg-desktop-portal-termfilechooser/config".text = lib.mkIf config.programs.yazi.enable ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      env=TERMCMD=kitty --class "terminal-file-picker"
      default_dir=$HOME
      open_mode=suggested
      save_mode=last
    '';

    portal = lib.mkIf config.programs.yazi.enable {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];
      config = {
        common = {
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      };
    };
  };
}
