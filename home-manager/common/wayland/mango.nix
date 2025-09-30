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

        browser = "librewolf";
        terminal = "kitty";
        menu = "bemenu";
        mod = "SUPER";
      in
        key_value {
          monitorrule =
            [
              # "name,mfact,nmaster,layout,transform,scale,x,y,width,height,refreshrate"
              ["DP-1" "0.50" "1" "vertical_dwindle" "1" "1" "0" "0" "1920" "1080" "60"]
              ["HDMI-A-1" "0.50" "1" "dwindle" "0" "1" "1080" "0" "1920" "1080" "60"]
              ["DVI-I-1" "0.50" "1" "vertical_dwindle" "3" "1" "3000" "0" "1920" "1080" "60"]
            ]
            |> map (builtins.concatStringsSep ",");

          env = [
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          ];

          exec-once = [
            "mako &"
            "wbg -s ${config.stylix.image} &"
          ];

          new_is_master = 0;
          default_mfact = 0.5;

          drag_tile_to_tile = 1;
          ov_tab_mode = 1;
          enable_hotarea = 0;
          focus_on_activate = 0;
          smartgaps = 1;

          view_current_to_back = 0;
          focus_cross_monitor = 1;
          exchange_cross_monitor = 1;
          # scratchpad_cross_monitor = 1;

          repeat_rate = 50;
          repeat_delay = 130;
          # xkb_rules_layout = "us,us";
          # xkb_rules_variant = "colemak_dh,intl";
          # xkb_rules_options = "grp:shift_caps_toggle";
          accel_profile = 0;
          trackpad_natural_scrolling = 1;

          border_radius = 0;
          no_radius_when_single = 1;
          blur = 0;
          shadows = 0; # Some error in the logs about shadows + corner radius?
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
          fadein_begin_opacity = 0.5;
          fadeout_begin_opacity = 0.7;
          animation_duration_move = 180;
          animation_duration_open = 300;
          animation_duration_tag = 280;
          animation_duration_close = 300;

          axisbind = [
            "SUPER,UP,viewtoleft_have_client"
            "SUPER,Down,viewtoright_have_client"
          ];

          bind =
            [
              "${mod}+CTRL+SHIFT,Q,quit"
              "${mod},v,togglefloating"
              "${mod}+CTLR,v,toggleoverlay"
              "${mod},H,togglemaxmizescreen"
              "NONE,F11,togglefullscreen"
              "${mod},r,reload_config"

              "${mod},minus,toggle_scratchpad"
              "${mod}+SHIFT,underscore,minimized"
              "${mod}+CTRL,minus,restore_minimized"

              # application specific
              "${mod}+CTRL,C,spawn_shell,cmus-remote -u || ${terminal} --class cmus cmus"
              "${mod}+CTRL,B,spawn,cmus-remote -n"
              "${mod}+CTRL,Z,spawn,cmus-remote -r"
              "${mod}+CTRL,M,spawn_shell,cmus-remote -C 'toggle aaa_mode'"

              "${mod},L,spawn,makoctl dismiss"
              "${mod},U,spawn,makoctl menu -- ${menu} --accept-single"
              "${mod},Y,spawn,makoctl restore"

              "${mod},return,spawn,${terminal}"
              "${mod},Z,spawn,${browser}"

              "${mod}, K, spawn, ${terminal} --hold aerc"

              "${mod},semicolon,spawn,bemenu-run"
              "${mod}+SHIFT,colon,spawn,passmenu_custom"

              "${mod}+SHIFT,B,spawn,${terminal} --hold btm --default_widget_type=processes --expanded"
              "${mod},P,spawn,directories_bemenu.sh"

              "${mod}+SHIFT,D,killclient,"
              "${mod},Return,spawn,${terminal}"

              # control windows
              "${mod},Tab,toggleoverview"
              "${mod},n,focusdir,left"
              "${mod},e,focusdir,down"
              "${mod},i,focusdir,up"
              "${mod},o,focusdir,right"

              "${mod}+CTRL,n,exchange_client,left"
              "${mod}+CTRL,e,exchange_client,down"
              "${mod}+CTRL,i,exchange_client,up"
              "${mod}+CTRL,o,exchange_client,right"

              "${mod},t,switch_layout"
              "${mod}+SHIFT,n,setmfact,-0.03"
              "${mod}+SHIFT,e,setsmfact,+0.03"
              "${mod}+SHIFT,i,setsmfact,-0.03"
              "${mod}+SHIFT,o,setmfact,+0.03"

              # control monitors
              "${mod},comma,focusmon,left"
              "${mod},period,focusmon,right"
              "${mod}+CTRL,comma,tagmon,left"
              "${mod}+CTRL,period,tagmon,right"
            ]
            # control tags
            ++ (concatMap (tag: [
                (tag_keybind "${mod}" "view" tag)
                (tag_keybind "${mod}+CTRL" "toggleview" tag)
              ])
              gen_tags)
            ++ (zipLists gen_tags shift_nums
              |> concatMap ({
                fst,
                snd,
              }: [
                "${mod}+SHIFT,${snd},tag,${fst}"
                "${mod}+CTRL+SHIFT,${snd},toggletag,${fst}"
              ]));

          mousebind = [
            # Mousebinds with a modifier work everywhere, without a modifier only in overview mode
            "${mod},btn_left,moveresize,curmove"
            "${mod},btn_right,moveresize,curresize"
            "${mod}+SHIFT,btn_right,killclient"
            "NONE,btn_left,toggleoverview,-1"
            "NONE,btn_right,killclient,0"
          ];

          windowrule = [
            "isopensilent:1,monitor:DP-1,appid:cmus"
            "isopensilent:1,monitor:DVI-I-1,appid:vesktop"
            "animation_type_open:fade,appid:pinentry"
            "animation_type_close:none,appid:pinentry"
          ];
        };

      xdg.configFile."mango/autostart_sh" = {
        text = ''
          #!/usr/bin/env bash
          dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
          xdg-desktop-portal-wlr &

        '';
        # wlr-randr \
        #   --output DP-1 --preferred --left-of HDMI-A-1 --transform 90 \
        #   --output DVI-I-1 --preferred --right-of HDMI-A-1 --transform 270 &
        executable = true;
      };
    };
}
