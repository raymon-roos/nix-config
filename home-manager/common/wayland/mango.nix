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
        systemd = {
          enable = true;
          variables = ["--all"];
        };
        settings = let
          inherit (config.lib.stylix) colors;

          # shift as a modifier effects the bound key
          shift_nums = ["parenright" "exclam" "at" "numbersign" "code:13" "percent" "asciicircum" "ampersand" "asterisk" "code:18"];
          gen_tags = range 0 9 |> map toString;

          tag_keybind = bind: action: tag: "${bind},spawn,${tags_with_overlay} --action ${action} --tag ${tag}";

          browser = "librewolf";
          terminal = "kitty";
          menu = "bemenu";
          mod = "SUPER";

          # Creates separate derivations for each invocation, which is not ideal.
          # But there is no easy way in nushell to eval a string, and
          # closures can only be passed within modules, not scripts
          spawn_or_focus = {
            appID,
            cmd,
          }:
            pkgs.writers.writeNu "spawn_or_focus" ''
              mmsg get all-clients
                | from json
                | get clients
                | where appid == "${appID}"
                | first
                | match ($in | get id? | describe) {
                  nothing => (exec ${cmd})
                  int => (mmsg dispatch focusid $"client,($in.id)")
                }
            '';

          # Two separate layout cycles with one keybind, one for landscape mode, one for portrait mode
          cycle_layouts = pkgs.writers.writeNu "cycle_layouts" ''
            let monitor = mmsg get all-monitors | from json | get monitors | where active == true | first | select layout_symbol width height
            {T: scroller S: fair F: tile , VT: vertical_scroller VS: vertical_fair VF: vertical_tile}
              | get -o $monitor.layout_symbol
              | default (if ($monitor.width > $monitor.height) { 'tile' } else { 'vertical_tile' })
              | tee {notify-send --app-name mangowm $in}
              | mmsg dispatch $'setlayout,($in)'
          '';

          # Switch/toggle tags with transient overlay showing state of tags
          tags_with_overlay = pkgs.writers.writeNu "tags_with_overlay" ''
            const symbols = {
              active: {
                none: {1: '󰎤 ' 2: '󰎧 ' 3: '󰎪 ' 4: '󰎭 ' 5: '󰎱 ' 6: '󰎳 ' 7: '󰎶 ' 8: '󰎹 ' 9: '󰎼 '}
                some: {1: '󰼏 ' 2: '󰼐 ' 3: '󰼑 ' 4: '󰼒 ' 5: '󰼓 ' 6: '󰼔 ' 7: '󰼕 ' 8: '󰼖 ' 9: '󰼗 '}
              }
              inactive: {
                none: {1: '󰎦 ' 2: '󰎩 ' 3: '󰎬 ' 4: '󰎮 ' 5: '󰎰 ' 6: '󰎵 ' 7: '󰎸 ' 8: '󰎻 ' 9: '󰎾 '}
                some: {1: '󰎥 ' 2: '󰎨 ' 3: '󰎫 ' 4: '󰎲 ' 5: '󰎯 ' 6: '󰎴 ' 7: '󰎷 ' 8: '󰎺 ' 9: '󰎽 '}
              }
            }

            def main [--action: string, --tag: int] {
              if $action not-in ["view" "toggleview" "tagsilent" "toggletag"] or ($tag < 0 or $tag > 9) {
                return
              }

              mmsg dispatch $"($action),($tag)"

              mmsg get all-monitors
                | from json
                | get monitors
                | where active == true
                | get 0.tags
                | each {|t|
                  if $t.is_active { $symbols.active } else { $symbols.inactive }
                    | if $t.client_count > 0 { get some } else { get none }
                    | get $"($t.index)"
                }
                | str join
                | notify-send --app-name mangowm --category tags_overlay $in
            }
          '';
        in {
          monitorrule =
            [
              ["DP-1" "1" "1" "0" "0" "1920" "1080" "60"]
              ["HDMI-A-1" "0" "1" "1080" "0" "1920" "1080" "60"]
              ["DVI-I-1" "3" "1" "3000" "0" "1920" "1080" "60"]
            ]
            |> map (monitor:
              zipLists ["name" "rr" "scale" "x" "y" "width" "height" "refresh"] monitor
              |> map (m: "${m.fst}:${m.snd}")
              |> builtins.concatStringsSep ",");

          env = [
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          ];

          exec-once = [
            "mako &"
            "wbg -s ${config.stylix.image} &"
            "mmsg dispatch focusmon,HDMI-A-1" # Focus main monitor on startup
          ];

          circle_layout = "tile,vertical_tile,scroller,dwindle";

          scroller_structs = 0;
          scroller_default_proportion = 0.5;
          scroller_proportion_preset = "0.5,0.97";

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
          # xkb_rules_layout = "us,us";
          # xkb_rules_variant = "colemak_dh,intl";
          # xkb_rules_options = "grp:shift_caps_toggle";
          mouse_accel_profile = 0;
          trackpad_natural_scrolling = 1;

          border_radius = 7;
          no_radius_when_single = 1;
          blur = 1;
          blur_optimized = 1;
          shadows_size = 7;
          shadow_only_floating = 0;

          allow_tearing = 2;

          gappih = 2;
          gappiv = 2;
          gappoh = 3;
          gappov = 3;
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

          unfocused_opacity = 0.97;

          animations = 1;
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

          bind =
            [
              "${mod}+CTRL+SHIFT,Q,quit"
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

              "${mod}+CTRL,C,spawn_shell,cmus-remote -u || ${terminal} --app-id cmus cmus"
              "${mod}+CTRL,B,spawn,cmus-remote -n"
              "${mod}+CTRL,Z,spawn,cmus-remote -r"
              "${mod}+CTRL,M,spawn,cmus-remote -C 'toggle aaa_mode'"

              "${mod},K,spawn,${spawn_or_focus {
                appID = "email_client";
                cmd = "${terminal} --app-id email_client --hold aerc";
              }}"

              "${mod}+SHIFT,K,spawn,${spawn_or_focus {
                appID = "discord_client";
                cmd = "${terminal} --app-id discord_client concord";
              }}"

              "${mod}+SHIFT,B,spawn,${spawn_or_focus {
                appID = "process_manager_client";
                cmd = "${terminal} --app-id process_manager_client --hold btm --default_widget_type=processes --expanded";
              }}"

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

          tagrule =
            concatMap (tag: [
              "id:${tag},monitor_name:DP-1,layout_name:vertical_tile"
              "id:${tag},monitor_name:DVI-I-1,layout_name:vertical_tile"
            ])
            gen_tags;

          windowrule = [
            "isopensilent:1,monitor:DP-1,appid:cmus"
            "monitor:DVI-I-1,appid:discord_client"
            "animation_type_open:zoom,appid:org.gnupg.pinentry-qt"
            "animation_type_close:zoom,appid:org.gnupg.pinentry-qt"
            "noblur:1,appid:slurp"
            "isfloating:1,title:satty"
          ];

          layerrule = [
            "animation_type_open:slide,animation_type_close:slide,layer_name:menu"
          ];
        };
      };
    };
}
