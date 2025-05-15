{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    librewolf.settings = lib.mkForce {
      "layout.css.devPixelsPerPx" = "1.0"; # shrink ui
    };

    bemenu = lib.mkIf config.common.hyprland.enable {
      settings.border = lib.mkForce 1;
    };
  };

  stylix = {
    targets.bemenu.fontSize = 6;
  };

  wayland.windowManager.hyprland = lib.mkIf config.common.hyprland.enable {
    settings = {
      general = {
        gaps_in = 1;
        gaps_out = 2;
      };
      decoration = {
        blur.enabled = false;
        shadow.enabled = false;
      };
      input = {
        kb_layout = "us,us";
        kb_variant = "colemak_dh,intl";
        kb_options = "grp:shift_caps_toggle";
      };
      binde = [
        ", XF86MonBrightnessDown, exec, brightnessctl set '10%-' --min-value 10"
        ", XF86MonBrightnessUp, exec, brightnessctl set '10%+'"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ '5%-'; volume_indicator"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ '5%+'; volume_indicator"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
      ];
    };
  };

  services.mako.settings = {
    "category=indicator" = {
      history = 0;
      anchor = "top";
    };
  };

  home.packages = with pkgs; let
    volume_indicator =
      if config.programs.nushell.enable
      then
        writeScriptBin "vol_indicator" ''
          #!/usr/bin/env nu

          let vol = wpctl get-volume '@DEFAULT_AUDIO_SINK@'
              | parse 'Volume: {vol}'
              | get 0.vol
              | into int
              | $in * 100

          notify-send --expire-time 1000 \
              --category 'indicator' \
              --app-name 'wp-vol' \
              --hint $'int:value:($vol)' \
              $' ($vol)%'
        ''
      else
        writeShellScript "vol_indicator" ''
          volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')

          notify-send --expire-time 1000 \
              --category 'indicator' \
              --app-name 'wp-vol' \
              --hint "int:value:$volume" \
              " $volume"
        '';
  in
    lib.mkIf config.services.mako.enable [volume_indicator];
}
