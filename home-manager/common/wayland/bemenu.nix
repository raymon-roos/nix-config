{
  config,
  lib,
  ...
}: {
  programs.bemenu = lib.mkIf config.common.wayland.enable {
    enable = true;
    settings = {
      list = 8;
      center = true;
      width-factor = 0.2;
      line-height = 16;
      border = 2;
      border-radius = 6;
      prompt = "";
      ignorecase = true;
      single-instance = true;
      wrap = true;
      bdr = "#${config.lib.stylix.colors.base0D}";
    };
  };
}
