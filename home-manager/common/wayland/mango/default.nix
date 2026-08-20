{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with builtins;
with lib; {
  imports = [
    inputs.mango.hmModules.mango
    ./keybinds.nix
  ];

  options.common.mango.enable = mkEnableOption "DreamMaoMao's dwl-based eye-candy window manager";

  config =
    mkIf (
      config.common.wayland.enable
      && config.common.mango.enable
    ) {
      home = {
        sessionVariables = {
          MANGOCONFIG = "${config.xdg.configHome}/mango";
        };

        packages = with pkgs; [
          wbg
        ];
      };

      xdg = {
        portal = {
          enable = lib.mkForce true;
          extraPortals = [pkgs.xdg-desktop-portal-wlr];
          config = {
            common = {
              "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
              "org.freedesktop.impl.portal.ScreenShot" = ["wlr"];
            };
          };
        };
      };

      wayland.windowManager.mango = {
        enable = true;
        package = inputs.mango.packages.${pkgs.stdenv.hostPlatform.system}.mango;
        systemd = {
          enable = true;
          variables = ["--all"];
        };
        settings = let
          inherit (config.lib.stylix) colors;
        in {
          env = [
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          ];

          exec-once = [
            "systemctl --user start mango-session.target"
            "mako &"
            "wbg -s ${config.stylix.image} &"
          ];

          circle_layout = "tile,vertical_tile,scroller,dwindle";

          scroller_structs = 10;
          scroller_default_proportion = 0.5;
          scroller_proportion_preset = "0.5,1";

          new_is_master = 0;
          default_mfact = 0.5;

          drag_tile_to_tile = 1;
          ov_tab_mode = 1;
          enable_hotarea = 0;
          focus_on_activate = 0;
          smartgaps = 1;

          view_current_to_back = 0;
          focus_cross_monitor = 0;
          exchange_cross_monitor = 1;
          # scratchpad_cross_monitor = 1;

          repeat_rate = 50;
          repeat_delay = 130;
          mouse_accel_profile = 0;

          border_radius = lib.mkDefault 7;
          no_radius_when_single = 1;
          blur = lib.mkDefault 1;
          blur_optimized = 1;
          shadows_size = 7;
          shadow_only_floating = 0;

          allow_tearing = 2;

          gappih = lib.mkDefault 2;
          gappiv = lib.mkDefault 2;
          gappoh = lib.mkDefault 3;
          gappov = lib.mkDefault 3;
          borderpx = 1;
          rootcolor = "0x${colors.base03}ff";
          bordercolor = "0x${colors.base03}ff";
          focuscolor = "0x${colors.base0D}ff";
          maximizescreencolor = "0x89aa61ff";
          urgentcolor = "0xad401fff";
          scratchpadcolor = "0x516c93ff";
          globalcolor = "0xb153a7ff";

          cursor_theme = config.stylix.cursor.name;
          cursor_size = config.stylix.cursor.size;
          cursor_hide_timeout = 1;
          cursor_hide_on_keypress = 1;
          warpcursor = 1;

          unfocused_opacity = lib.mkDefault 0.97;

          animations = 1;
          layer_animations = 1;
          # animation_type_open = "zoom";
          # animation_type_close = "slide";
          animation_fade_in = 1;
          fadein_begin_opacity = 0.5;
          fadeout_begin_opacity = 0.7;
          animation_duration_move = 220;
          animation_duration_open = 290;
          animation_duration_tag = 300;
          animation_duration_close = 290;

          windowrule = [
            "animation_type_open:zoom,appid:org.gnupg.pinentry-qt"
            "animation_type_close:zoom,appid:org.gnupg.pinentry-qt"
            "noblur:1,appid:slurp"
            "isfloating:1,title:satty"
          ];

          layerrule = [
            "animation_type_open:zoom,animation_type_close:zoom,layer_name:menu"
          ];
        };
      };
    };
}
