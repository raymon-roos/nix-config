{
  config,
  lib,
  ...
}: {
  programs.bemenu = lib.mkIf config.common.wayland.enable {
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
      bdr = "#${config.lib.stylix.colors.base0D}";
    };
  };
}
