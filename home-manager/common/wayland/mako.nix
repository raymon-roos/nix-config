{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: {
  services.mako = lib.mkIf config.common.wayland.enable {
    enable = true;
    settings = {
      default-timeout = 20 * 1000;
      icons = 1;
      border-radius = 6;
      width = 250;

      # Transient and minimal notifications, like for changing WM layout (because I don't use a status bar)
      "app-name=window_manager" = lib.mkIf config.common.mango.enable {
        anchor = "top-center";
        default-timeout = "1000";
        group-by = "app-name";
        history = 0;
        text-alignment = "center";
        format = ''<b>%s</b>\n%b''; # Default, but without group count
        border-size = 0;
        width = 100;
      };

      "app-name=window_manager category=tags_overlay" = {
        font = "${osConfig.stylix.fonts.emoji.name} 12";
        width = 170;
        default-timeout = "700";
        background-color = "${"#" + config.lib.stylix.colors.base01}";
      };

      "app-name=window_manager category=osd" = {
        width = 120;
      };
    };
  };

  home.packages = lib.mkIf config.services.mako.enable [pkgs.libnotify];
}
