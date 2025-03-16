{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.gaming.enable = mkEnableOption "software and configs required to game on Linux";

  config = mkIf config.gaming.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraBwrapArgs = [
          "--bind $HOME/.xdg/local/share/steam $HOME"
          "--unsetenv XDG_CACHE_HOME"
          "--unsetenv XDG_CONFIG_HOME"
          "--unsetenv XDG_DATA_HOME"
          "--unsetenv XDG_STATE_HOME"
        ];
      };
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      extraPackages = with pkgs; [
        wineWayland
        gamescope
      ];
    };

    environment = {
      systemPackages = with pkgs; [
        # lutris
      ];

      etc = {
        "pulse/client.conf".text = ''
          cookie-file = ~/.xdg/local/share/pulse/cookie
        '';
      };
    };
  };
}
