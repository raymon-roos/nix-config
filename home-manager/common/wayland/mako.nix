{
  config,
  pkgs,
  lib,
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
      "app-name=mangowm" = lib.mkIf config.common.mango.enable {
        anchor = "top-center";
        default-timeout = "1000";
        group-by = "app-name";
        history = 0;
        text-alignment = "center";
        format = ''<b>%s</b>\n%b''; # Default, but without group count
        border-size = 0;
        width = 100;
      };
    };
  };

  home.packages = lib.mkIf config.services.mako.enable [pkgs.libnotify];
}
