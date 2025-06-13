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
    inputs.maomaowm.hmModules.maomaowm
  ];

  options.common.maomaowm.enable = mkEnableOption "MaomaoWM & co";

  config =
    mkIf (
      config.common.wayland.enable
      && config.common.maomaowm.enable
    ) {
      home = {
        sessionVariables = {
          MAOMAOCONFIG = "${config.xdg.configHome}/maomao";
        };

        packages = with pkgs; [
          xdg-desktop-portal-wlr
          wlr-randr
          wbg
        ];
      };

      programs.foot.enable = true;

      wayland.windowManager.maomaowm.enable = true;

      xdg.configFile."maomao/config.conf".text = let
        inherit (config.lib.stylix) colors;

        key_value = generators.toKeyValue {listsAsDuplicateKeys = true;};

        # shift as a modifier effects the bound key
        shift_nums = ["exclam" "at" "numbersign" "dollar" "percent" "asciicircum" "ampersand" "asterisk" "parenleft"];
        gen_tags = range 1 9 |> map toString;

        tag_keybind = mod: action: tag: "${mod},${tag},${action},${tag}";
      in
        {
          # monitorrule = [
          #   "DVI-I-1"
          #   "DP-1"
          # ];

          ov_tab_mode = 1;
          new_is_master = 0;
          focus_on_activate = 0;

          repeat_rate = 50;
          repeat_delay = 130;
          accel_profile = 0;
          trackpad_natural_scrolling = 1;

          gappih = 2;
          gappiv = 2;
          gappoh = 3;
          gappov = 3;
          borderpx = 1;
          rootcolor = "0x${colors.base03}ff";
          bordercolor = "0x${colors.base03}ff";
          focuscolor = "0x${colors.base0D}ff";
          maxmizescreencolor = "0x89aa61ff";
          urgentcolor = "0xad401fff";
          scratchpadcolor = "0x516c93ff";
          globalcolor = "0xb153a7ff";

          cursor_theme = config.stylix.cursor.name;
          cursor_size = config.stylix.cursor.size;
          smart_gaps = 1;

          animations = 1;
          animation_type_open = "zoom";
          animation_type_close = "slide";
          animation_fade_in = 1;
          zoom_initial_ratio = 0.5;
          fadein_begin_opacity = 0.5;
          fadeout_begin_opacity = 0.7;
          animation_duration_move = 200;
          animation_duration_open = 300;
          animation_duration_tag = 250;
          animation_duration_close = 400;
          animation_curve_open = "0.46,1.0,0.29,1";
          animation_curve_move = "0.46,1.0,0.29,1";
          animation_curve_tag = "0.46,1.0,0.29,1";
          animation_curve_close = "0.08,0.92,0,1";

          axisbind = [
            "SUPER,UP,viewtoleft_have_client"
            "SUPER,Down,viewtoright_have_client"
          ];
          # keybindings
          bind =
            [
              "SUPER+CTRL+SHIFT,Q,quit"
              "SUPER,r,reload_config"

              "SUPER+SHIFT,D,killclient,"
              "SUPER,semicolon,spawn,bemenu-run"
              "SUPER+SHIFT,colon,spawn,passmenu_custom"
              "SUPER,Return,spawn,foot"

              "SUPER,Tab,toggleoverview"
              "SUPER,n,focusdir,left"
              "SUPER,e,focusdir,down"
              "SUPER,i,focusdir,up"
              "SUPER,o,focusdir,right"

              "SUPER+CTRL,n,exchange_client,left"
              "SUPER+CTRL,e,exchange_client,down"
              "SUPER+CTRL,i,exchange_client,up"
              "SUPER+CTRL,o,exchange_client,right"

              "SUPER,t,switch_layout"

              "SUPER,comma,focusmon,left"
              "SUPER,period,focusmon,right"
              "SUPER+SHIFT,less,tagmon,left"
              "SUPER+SHIFT,greater,tagmon,right"
            ]
            ++ (concatMap (tag: [
                (tag_keybind "SUPER" "view" tag)
                (tag_keybind "SUPER+CTRL" "toggleview" tag)
              ])
              gen_tags)
            ++ (
              zipLists gen_tags shift_nums
              |> concatMap ({
                fst,
                snd,
              }: [
                "SUPER+SHIFT,${snd},tag,${fst}"
                "SUPER+CTRL+SHIFT,${snd},toggletag,${fst}"
              ])
            );

          mousebind = [
            "SUPER,btn_left,moveresize,curmove"
            "SUPER,btn_right,moveresize,curresize"
            "NONE,btn_left,toggleoverview,-1"
          ];
        }
        |> key_value;

      xdg.configFile."maomao/autostart_sh" = {
        text = ''
          #!/usr/bin/env sh
          dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
          xdg-desktop-portal-wlr &

          wlr-randr \
              --output DP-1 --preferred --left-of HDMI-A-1 --transform 90 \
              --output DVI-I-1 --preferred --right-of HDMI-A-1 --transform 270 &

          pkill wbg; wbg ${config.stylix.image} &
          pkill mako; mako &
        '';
        executable = true;
      };
    };
}
