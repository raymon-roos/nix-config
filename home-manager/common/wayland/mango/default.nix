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

          exec_once = [
            "systemctl --user start mango-session.target"
            "mako &"
            "wbg -s ${config.stylix.image} &"
          ];

          circle_layout = "tile,scroller,dwindle";

          scroller = {
            structs = 10;
            default_proportion = 0.5;
            proportion_preset = "0.5,1";
          };

          new_is_master = 0;
          default_master_factor = 0.5;

          drag_tile_to_tile = 1;
          enable_hotarea = 0;
          jump_labels = "NEIOARSTMGQWFPLUY;XCDV/.,H";
          jump_label_decorate = {
            font_desc = "monospace Bold 10";
            border_width = 2;
            padding_x = 8;
            padding_y = 6;
          };
          focus_on_activate = 0;
          smart_gaps = 1;

          view_current_to_back = 0;
          focus_cross_monitor = 0;
          exchange_cross_monitor = 1;
          scratchpad_cross_monitor = 1;

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

          gap_inner_horizontal = lib.mkDefault 2;
          gap_inner_vertical = lib.mkDefault 2;
          gap_outer_horizontal = lib.mkDefault 3;
          gap_outer_vertical = lib.mkDefault 3;
          border_px = 1;
          root_color = "0x${colors.base03}ff";
          border_color = "0x${colors.base03}ff";
          focus_color = "0x${colors.base0D}ff";
          maximized_screen_color = "0x89aa61ff";
          urgent_color = "0xad401fff";
          scratchpad_color = "0x516c93ff";
          global_color = "0xb153a7ff";

          cursor = {
            theme = config.stylix.cursor.name;
            size = config.stylix.cursor.size;
            hide_timeout = 1;
            hide_on_keypress = 1;
          };
          warp_cursor = 1;

          unfocused_opacity = lib.mkDefault 0.97;

          animations = 1;
          layer_animations = 1;
          # animation_type_open = "zoom";
          # animation_type_close = "slide";
          fade_in_begin_opacity = 0.5;
          fade_out_begin_opacity = 0.7;
          animation = {
            fade_in = 1;
            duration_move = 220;
            duration_open = 290;
            duration_tag = 300;
            duration_close = 290;
          };

          window_rule = [
            "animation_type_open:zoom,app_id:org.gnupg.pinentry-qt"
            "animation_type_close:zoom,app_id:org.gnupg.pinentry-qt"
            "no_blur:1,app_id:slurp"
            "is_floating:1,title:satty"
            "is_named_scratchpad:1,no_blur:1,focused_opacity:0.9,unfocused_opacity:0.8,app_id:scratch-term"
          ];

          layer_rule = [
            "animation_type_open:zoom,animation_type_close:zoom,layer_name:menu"
          ];
        };
      };
    };
}
