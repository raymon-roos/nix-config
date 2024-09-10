{config, ...}: {
  services = {
    hypridle = {
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
            on-timeout = "notify-send 'idle in 10 seconds'";
          }
          {
            timeout = 310;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          # {
          #   timeout = 900;
          #   on-timeout = "loginctl lock-session";
          # }
        ];
      };
    };

    mako = {
      enable = true;
      defaultTimeout = 20 * 1000;
      borderRadius = 6;
    };
  };

  programs = {
    bemenu = {
      enable = true;
      settings = {
        list = 6;
        center = true;
        width-factor = 0.2;
        border = 2;
        border-radius = 6;
        prompt = "";
        ignorecase = true;
        single-instance = true;
        wrap = true;
      };
    };

    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = false;
          no_fade_in = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 1;
            blur_size = 8;
          }
        ];

        label = [
          {
            text = "cmd[update:60000] date '+%a %b %d %Y %R'";
            text_align = "center";
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 15;
            font_family = config.stylix.fonts.monospace.name;
            rotate = 0;
            position = "0, -20";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            size = "400, 40";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 2;
            rounding = -0.15;
            shadow_passes = 1;
          }
        ];
      };
    };
  };
}
