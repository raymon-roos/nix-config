{
  config,
  lib,
  ...
}: {
  programs.hyprlock =
    lib.mkIf (
      config.common.wayland.enable
      && config.common.lockscreen.enable
    ) {
      enable = true;
      settings = {
        general = {
          hide_cursor = false;
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
}
