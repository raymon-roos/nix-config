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
      manager = {
        show_hidden = true;
      };
    };
    keymap = {
      manager.prepend_keymap = [
        {
          run = "quit --no-cwd-file";
          on = ["q"];
        }
        {
          run = "quit";
          on = ["<C-g>"];
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

  xdg = {
    configFile."xdg-desktop-portal-termfilechooser/config".text = lib.mkIf config.programs.yazi.enable ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      env=TERMCMD=kitty --class "terminal-file-picker"
      default_dir=$HOME
      open_mode=suggested
      save_mode=last
    '';

    portal = {
      enable = true;
      extraPortals = lib.mkIf config.programs.yazi.enable [pkgs.xdg-desktop-portal-termfilechooser];
      config = {
        common = {
          default = "hyprland";
          "org.freedesktop.impl.portal.FileChooser" = lib.mkIf config.programs.yazi.enable "termfilechooser";
        };
        hyprland = {
          default = "hyprland";
          "org.freedesktop.impl.portal.FileChooser" = lib.mkIf config.programs.yazi.enable "termfilechooser";
        };
      };
    };
  };
}
