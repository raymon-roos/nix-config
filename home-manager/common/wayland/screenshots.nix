{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = mkIf config.common.wayland.enable {
    home.packages = [pkgs.grimblast];

    programs.satty = {
      enable = true;
      settings = {
        general = {
          output-filename = "/tmp/screenshot_%Y-%m-%d_%H:%M:%S.png";
          annotation-size-factor = 0.8;
        };
      };
    };

    wayland.windowManager.hyprland.settings.bind =
      mkIf config.common.hyprland.enable
      (let
        hyprscreenshot =
          pkgs.writeShellScriptBin "hyprscreenshot"
          ''
            hyprctl --batch "
            keyword decoration:dim_inactive false; \
            keyword decoration:inactive_opacity 1;"

            grimblast --wait "0.2" --freeze --notify edit area - | satty -f -

            hyprctl reload config-only

            [ $(fd --max-depth 1 'screenshot_' /tmp | wc -l) -ge 1 ] \
              && ripdrag --basename --icon-size 128 --content-width 400 --content-height 280 /tmp/screenshot_*
          '';
      in [
        "$mainMod CONTROL, P, exec, ${lib.getExe hyprscreenshot}"
      ]);
  };
}
