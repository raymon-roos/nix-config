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
    keymap = {
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

    portal = lib.mkIf config.programs.yazi.enable {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];
      config = {
        common = {
          default = "hyprland";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
        hyprland = lib.mkIf config.common.hyprland.enable {
          default = "hyprland";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      };
    };
  };
}
