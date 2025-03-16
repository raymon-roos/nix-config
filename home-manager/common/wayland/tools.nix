{
  config,
  lib,
  ...
}:
with lib; {
  config = {
    services = {
      hypridle = mkIf config.desktop-config.lockscreen.enable {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            ignore_systemd_inhibit = false;
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      mako = mkIf config.desktop-config.hyprland.enable {
        enable = true;
        defaultTimeout = 20 * 1000;
        borderRadius = 6;
      };
    };

    programs = {
      bemenu = mkIf config.desktop-config.hyprland.enable {
        enable = true;
        settings = {
          list = 6;
          center = true;
          width-factor = 0.2;
          border = 1;
          border-radius = 6;
          prompt = "";
          ignorecase = true;
          single-instance = true;
          wrap = true;
        };
      };

      hyprlock = mkIf config.desktop-config.lockscreen.enable {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 5;
            hide_cursor = false;
            no_fade_in = true;
          };
          background = lib.mkForce [
            {
              path = "screenshot";
              blur_passes = 2;
              blur_size = 6;
            }
          ];
          input-field = {
            size = "260, 40";
          };
          label = [
            {
              text = "cmd[update:60000] date '+%a %b %d %Y %R'";
              text_align = "center";
              font_size = 13;
              position = "0, 70";
              halign = "center";
              valign = "center";
            }
            {
              text = " $LAYOUT";
              text_align = "center";
              font_size = 11;
              position = "0, -40";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };
    };
  };
}
