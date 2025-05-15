{
  config,
  lib,
  ...
}: {
  services.hypridle = lib.mkIf config.common.lockscreen.enable {
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
          on-timeout = "brightnessctl --save && brightnessctl set '2%'";
          on-resume = "brightnessctl --restore";
        }
        {
          timeout = 320;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 400;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
