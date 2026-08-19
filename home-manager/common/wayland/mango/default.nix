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

          # shift as a modifier affects the bound key
          shift_nums = ["parenright" "exclam" "at" "numbersign" "code:13" "percent" "asciicircum" "ampersand" "asterisk" "code:18"];
          gen_tags = range 0 9 |> map toString;

          tag_keybind = bind: action: tag: "${bind},spawn,${tags_with_overlay} --action ${action} --tag ${tag}";

          browser = "librewolf";
          terminal = "kitty";
          menu = "bemenu";
          mod = "SUPER";

          writeNuBin = name: pkgs.writers.writeNuBin name ./${name}.nu |> lib.getExe;

          spawn_or_focus = writeNuBin "spawn_or_focus";
          cycle_layouts = writeNuBin "cycle_layouts";
          tags_with_overlay = writeNuBin "tags_with_overlay";
          quit_menu = writeNuBin "quit_menu";
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

          axisbind = [
            "${mod},UP,viewtoleft_have_client"
            "${mod},Down,viewtoright_have_client"
          ];

          binds =
            [
              "${mod}+CTRL+SHIFT,Q,spawn,${quit_menu}"
              "${mod},v,togglefloating"
              "${mod},H,togglemaximizescreen"
              "NONE,F11,togglefullscreen"
              "${mod},r,reload_config"

              "${mod},minus,toggle_scratchpad"
              "${mod}+SHIFT,underscore,minimized"
              "${mod}+CTRL,minus,restore_minimized"

              # application specific
              "${mod},return,spawn,${terminal}"
              "${mod},Z,spawn,${browser}"
              "${mod}+SHIFT,Z,spawn,${browser} --private-window"

              "${mod},K,spawn,${spawn_or_focus} --appID 'email_client' --cmd '${terminal} --app-id email_client --hold aerc'"

              "${mod}+SHIFT,K,spawn,${spawn_or_focus} --appID 'discord_client' --cmd '${terminal} --app-id discord_client concord'"

              "${mod}+SHIFT,B,spawn,${spawn_or_focus} --appID 'process_manager' --cmd '${terminal} --app-id process_manager --hold btm'"

              "${mod},L,spawn,makoctl dismiss"
              "${mod},U,spawn,makoctl menu -- ${menu} --accept-single"
              "${mod},Y,spawn,makoctl restore"

              "${mod},semicolon,spawn,bemenu-run"
              "${mod}+SHIFT,colon,spawn,passmenu_custom"
              "${mod},P,spawn,directories_bemenu.sh"

              "${mod}+SHIFT,D,killclient,"

              # control windows
              "${mod}+CTRL,Tab,view,-1"
              "${mod},Tab,toggleoverview"
              "${mod},n,focusdir,left"
              "${mod},e,focusdir,down"
              "${mod},i,focusdir,up"
              "${mod},o,focusdir,right"

              "${mod}+CTRL,n,exchange_client,left"
              "${mod}+CTRL,e,exchange_client,down"
              "${mod}+CTRL,i,exchange_client,up"
              "${mod}+CTRL,o,exchange_client,right"

              "${mod}+CTRL+SHIFT,n,scroller_stack,left"
              "${mod}+CTRL+SHIFT,e,scroller_stack,down"
              "${mod}+CTRL+SHIFT,i,scroller_stack,up"
              "${mod}+CTRL+SHIFT,o,scroller_stack,right"

              "${mod}+CTRL,t,switch_proportion_preset"
              "${mod},t,spawn,${cycle_layouts}"
              "${mod}+SHIFT,n,setmfact,-0.03"
              "${mod}+SHIFT,o,setmfact,+0.03"

              # control monitors
              "${mod},comma,focusmon,left"
              "${mod},period,focusmon,right"
              "${mod}+CTRL,comma,tagmon,left"
              "${mod}+CTRL,period,tagmon,right"
            ]
            ++ (
              lib.lists.optional config.common.lockscreen.enable
              "${mod}+CTRL,Q,spawn_shell,pidof hyprlock || hyprlock"
            )
            # control tags
            ++ (concatMap (tag: [
                (tag_keybind "${mod},${tag}" "view" tag)
                (tag_keybind "${mod}+CTRL,${tag}" "toggleview" tag)
              ])
              gen_tags)
            ++ (zipLists gen_tags shift_nums
              |> concatMap (x: [
                (tag_keybind "${mod}+SHIFT,${x.snd}" "tagsilent" x.fst)
                (tag_keybind "${mod}+CTRL+SHIFT,${x.snd}" "toggletag" x.fst)
              ]));

          mousebind = [
            # Mousebinds with a modifier work everywhere, without a modifier only in overview mode
            "${mod},btn_left,moveresize,curmove"
            "${mod},btn_right,moveresize,curresize"
            "${mod}+SHIFT,btn_right,killclient"
          ];

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
