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
        default-timeout = 1000;
        group-by = "app-name";
        history = 0;
        text-alignment = "center";
        format = ''<b>%s</b>\n%b''; # Default, but without group count
        border-size = 0;
        width = 100;
      };

      "app-name=window_manager category=tags_overlay" = {
        font = "${osConfig.stylix.fonts.emoji.name} 11";
        width = 190;
        default-timeout = 1000;
        background-color = "${"#" + config.lib.stylix.colors.base01}";
      };

      "app-name=window_manager category=osd" = {
        width = 120;
      };

      "app-name=window_manager category=info_overlay" = {
        width = 190;
        default-timeout = "1400";
        border-size = 1;
      };

      "app-name=agenda_overview" = {
        font = "${osConfig.stylix.fonts.monospace.name} 8";
        width = 600;
        height = 700;
        default-timeout = 10 * 1000;
        border-size = 1;
        anchor = "center";
        group-by = "app-name";
        history = 0;
        format = ''<b>%s</b>\n%b'';
      };
    };
  };

  home.packages = lib.mkIf config.services.mako.enable [pkgs.libnotify];
}
