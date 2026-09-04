{
  config,
  lib,
  ...
}: let
  inherit (config) common;
in {
  services.hypridle = lib.mkIf (common.wayland.enable && common.lockscreen.enable) {
    enable = true;
    settings = {
      general =
        {
          lock_cmd = "pidof hyprlock || hyprlock --grace 5 --quiet";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
        }
        // lib.optionalAttrs common.hyprland.enable {
          after_sleep_cmd = "hyprctl dispatch dpms on";
        }
        // lib.optionalAttrs common.mango.enable {
          after_sleep_cmd = "mmsg dispatch wakeup_monitor";
        };

      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl --save && brightnessctl set '2%'";
          on-resume = "brightnessctl --restore";
        }

        ({
            timeout = 320;
          }
          // lib.optionalAttrs common.hyprland.enable {
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          // lib.optionalAttrs common.mango.enable {
            on-timeout = "mmsg dispatch sleep_monitor";
            on-resume = "mmsg dispatch wakeup_monitor";
          })

        {
          timeout = 400;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
