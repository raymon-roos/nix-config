{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.dev.go.enable = mkEnableOption "Go dev tools";

  config = mkIf config.common.dev.go.enable {
    programs.go = {
      enable = true;
      goBin = ".xdg/local/bin";
      goPath = ".xdg/local/share/go";
    };

    home.packages = with pkgs; [
      gopls
      revive
      gofumpt
      air
    ];
  };
}
