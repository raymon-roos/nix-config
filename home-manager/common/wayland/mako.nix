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
    };
  };

  home.packages = lib.mkIf config.services.mako.enable [pkgs.libnotify];
}
