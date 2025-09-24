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
          xdg-desktop-portal-wlr
          wlr-randr
          wbg
        ];
      };

      wayland.windowManager.mango.enable = true;

      xdg.configFile."mango/config.conf".text = let
        inherit (config.lib.stylix) colors;

        key_value = generators.toKeyValue {listsAsDuplicateKeys = true;};

        # shift as a modifier effects the bound key
        shift_nums = ["exclam" "at" "numbersign" "dollar" "percent" "asciicircum" "ampersand" "asterisk" "parenleft"];
        gen_tags = range 1 9 |> map toString;

        tag_keybind = mod: action: tag: "${mod},${tag},${action},${tag}";
      in
        key_value {
          # monitorrule = [
          #   "DVI-I-1"
          #   "DP-1"
          # ];
          env = [
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          ];

          exec-once = [
            "mako &"
            "wbg ${config.stylix.image} &"
          ];

          new_is_master = 0;
          default_mfact = 0.5;

          drag_tile_to_tile = 1;
          ov_tab_mode = 1;
          focus_on_activate = 0;
          smartgaps = 1;

          focus_cross_monitor = 1;
          exchange_cross_monitor = 1;
          # scratchpad_cross_monitor = 1;

          repeat_rate = 50;
          repeat_delay = 130;
          accel_profile = 0;
          trackpad_natural_scrolling = 1;

          border_radius = 6;
          no_radius_when_single = 1;
          blur = 1;
          shadows = 1;
          shadows_size = 7;
          shadow_only_floating = 0;

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
          cursor_hide_timeout = 1;

          unfocused_opacity = 0.97;

          animations = 1;
          # animation_type_open = "zoom";
          # animation_type_close = "slide";
          animation_fade_in = 1;
          # zoom_initial_ratio = 0.5;
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

          # windowrule = [
          #   "isopensilent:1,title:vesktop"
          # ];

          axisbind = [
            "SUPER,UP,viewtoleft_have_client"
            "SUPER,Down,viewtoright_have_client"
          ];
          bind =
            [
              "SUPER+CTRL+SHIFT,Q,quit"
              "SUPER,v,togglefloating"
              "SUPER+CTLR,v,togglefloating"
              "SUPER,H,togglemaxmizescreen"
              "none,F11,togglefullscreen"
              "SUPER,r,reload_config"

              "SUPER,minus,toggle_scratchpad"
              "SUPER+SHIFT,minus,minimized"
              "SUPER+SHIFT,minus,restore_minimized"

              # application specific
              "SUPER+CONTROL,C,spawn_shell,cmus-remote -u || kitty --class cmus cmus"
              "SUPER+CONTROL,B,spawn,cmus-remote -n"
              "SUPER+CONTROL,Z,spawn,cmus-remote -r"
              "SUPER+CONTROL,M,spawn,cmus-remote -C 'toggle aaa_mode'"

              "SUPER,L,spawn,makoctl dismiss"
              "SUPER,U,spawn,makoctl menu -- bemenu --accept-single"
              "SUPER,Y,spawn,makoctl restore"

              "SUPER,return,spawn,kitty"
              "SUPER,Z,spawn,$browser"

              "SUPER, K, spawn, kitty --hold aerc"

              "SUPER,semicolon,spawn,bemenu-run"
              "SUPER+SHIFT,semicolon,spawn,passmenu_custom"

              "SUPER+SHIFT,B,spawn,kitty --hold btm --default_widget_type=processes --expanded"
              "SUPER,P,spawn,directories_bemenu.sh"

              "SUPER+SHIFT,D,killclient,"
              "SUPER,Return,spawn,kitty"

              # control windows
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
              "SUPER+SHIFT,n,setmfact,-0.10"
              "SUPER+SHIFT,e,setsmfact,+0.10"
              "SUPER+SHIFT,i,setsmfact,-0.10"
              "SUPER+SHIFT,o,setmfact,+0.10"

              # control monitors
              "SUPER,comma,focusmon,left"
              "SUPER,period,focusmon,right"
              "SUPER+SHIFT,less,tagmon,left"
              "SUPER+SHIFT,greater,tagmon,right"
            ]
            # control tags
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
            # Mousebinds with a modifier work everywhere, without a modifier only in overview mode
            "mousebind=SUPER,btn_left,moveresize,curmove"
            "mousebind=SUPER,btn_right,moveresize,curresize"
            "mousebind=SUPER+SHIFT,btn_right,killclient"
            "mousebind=NONE,btn_left,toggleoverview,-1"
            "mousebind=NONE,btn_right,killclient,0"
          ];
        };

      xdg.configFile."mango/autostart_sh" = {
        text = ''
          #!/usr/bin/env sh
          dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
          xdg-desktop-portal-wlr &

          wlr-randr \
            --output DP-1 --preferred --left-of HDMI-A-1 --transform 90 \
            --output DVI-I-1 --preferred --right-of HDMI-A-1 --transform 270 &
        '';
        executable = true;
      };
    };
}
