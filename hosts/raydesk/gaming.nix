{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.gaming.enable = mkEnableOption "software and configs required to game on Linux";

  config = mkIf config.gaming.enable {
    programs = {
      steam = {
        enable = true;
        package = pkgs.steam.override {
          extraBwrapArgs = [
            "--bind $HOME/files/games/steam $HOME"
            "--unsetenv XDG_CACHE_HOME"
            "--unsetenv XDG_CONFIG_HOME"
            "--unsetenv XDG_DATA_HOME"
            "--unsetenv XDG_STATE_HOME"
          ];
        };
        extraCompatPackages = [
          pkgs.proton-ge-bin
        ];
      };
      gamescope = {
        enable = true;
        args = [
          "-W 1920"
          "-H 1080"
          "-r 60"
          "-f"
          "--force-grab-cursor"
        ];
      };
      gamemode = {
        enable = true;
        settings = {
          general.renice = 17; # Automatically negated. -20 is highest prio, 19 lowest
          custom = let
            hyprgamemode = pkgs.writeShellScriptBin "hyprgamemode" ''
              # If animations are enabled, disable them and other graphical decorations
              HYPRGAMEMODE="$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')"
              if [ "$HYPRGAMEMODE" = 1 ] ; then
                  hyprctl --batch "\
                      keyword animations:enabled 0;\
                      keyword decoration:shadow:enabled 0;\
                      keyword decoration:blur:enabled 0;\
                      keyword decoration:rounding 0"
                  exit
              fi
              hyprctl reload # Reload config, discarding runtime configuration
            '';
          in {
            start =
              "${pkgs.libnotify}/bin/notify-send 'GameMode started' --time 2000"
              + lib.optionalString config.home-manager.users.ray.common.hyprland.enable " && ${lib.getExe hyprgamemode}";
            end =
              "${pkgs.libnotify}/bin/notify-send 'GameMode stopped' --time 2000"
              + lib.optionalString config.home-manager.users.ray.common.hyprland.enable " && ${lib.getExe hyprgamemode}";
          };
        };
      };
    };

    users.users.ray.extraGroups = ["gamemode"];

    environment = {
      systemPackages = with pkgs; [
        wineWayland
        gamescope
      ];

      etc = {
        "pulse/client.conf".text = ''
          cookie-file = ~/.xdg/local/share/pulse/cookie
        '';
      };
    };
  };
}
