{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config =
    mkIf (
      config.common.wayland.enable
      && config.common.hyprland.enable
    ) {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.variables = ["--all"];

        plugins = [
          pkgs.hyprlandPlugins.hyprsplit
        ];

        settings = with builtins; {
          env = [
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          ];

          # debug.disable_logs = false;
          debug.full_cm_proto = true; # https://www.reddit.com/r/hyprland/comments/1kihakq/gamescope_wont_work_on_hyprland_works_on_kde/

          "$terminal" = "kitty";
          "$browser" = "librewolf";
          "$menu" = "bemenu";

          exec-once = [
            "mako &"
            # "fd -tf . "$XDG_PICTURES_DIR/wallpapers" | shuf -n 1 | xargs -i swaybg --mode fill --image {} &"
          ];

          general = {
            gaps_in = lib.mkDefault 2;
            gaps_out = lib.mkDefault 3;
            border_size = 1;
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };

          decoration = {
            rounding = 7;
            active_opacity = 1.0;
            inactive_opacity = 0.95;
            dim_inactive = true;
            dim_strength = 0.15;
            shadow = {
              enabled = lib.mkDefault true;
              range = 6;
            };
            blur = {
              enabled = lib.mkDefault true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = true;
            first_launch_animation = false;
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
            animation = [
              "windows, 1, 2, myBezier"
              "windowsOut, 1, 2, default, popin 80%"
              "border, 1, 2, default"
              "borderangle, 1, 2, default"
              "fade, 1, 2, default"
              "workspaces, 1, 2, default"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
            force_split = 2;
          };

          master = {
            new_status = "slave"; # unfortunate option naming...
          };

          misc = {
            # Be rid of this anime nonsense
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
          };

          ecosystem = {
            no_donation_nag = true;
            no_update_news = true;
          };

          input = {
            repeat_delay = 130;
            repeat_rate = 50;
            follow_mouse = 1;
            accel_profile = "flat";
            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
            touchpad = {
              natural_scroll = true;
            };
          };

          cursor = {
            enable_hyprcursor = false;
            default_monitor = "HDMI-A-1";
            hide_on_key_press = true;
          };

          plugin.hyprsplit = {
            num_workspaces = 10;
          };

          "$mainMod" = "SUPER";

          bind =
            [
              # general/tiling
              "$mainMod CONTROL SHIFT, Q, exit,"
              "$mainMod, V, togglefloating,"
              "$mainMod SHIFT, P, pseudo,"
              "$mainMod, T, togglesplit,"
              "$mainMod, H, fullscreen, 1"
              ", F11, fullscreen, 0"

              # scratch space
              "$mainMod, minus, togglespecialworkspace, magic"
              "$mainMod SHIFT, minus, movetoworkspace, special:magic"

              # application specific
              "$mainMod CONTROL, C, exec, cmus-remote -u || $terminal --class cmus cmus"
              "$mainMod CONTROL, B, exec, cmus-remote -n"
              "$mainMod CONTROL, Z, exec, cmus-remote -r"
              "$mainMod CONTROL, M, exec, cmus-remote -C 'toggle aaa_mode'"

              "$mainMod, L, exec, makoctl dismiss"
              "$mainMod, U, exec, makoctl menu -- $menu --accept-single"
              "$mainMod, Y, exec, makoctl restore"

              "$mainMod, return, exec, $terminal"
              "$mainMod, Z, exec, $browser"

              "$mainMod, semicolon, exec, bemenu-run"
              "$mainMod SHIFT, semicolon, exec, passmenu_custom"

              "$mainMod SHIFT, B, exec, $terminal --hold btm --default_widget_type=processes --expanded"
              "$mainMod, P, exec, directories_bemenu.sh"

              (
                if config.programs.aerc.enable
                then "$mainMod, K, exec, kitty --hold aerc"
                else if config.programs.thunderbird.enable
                then "$mainMod, K, exec, thunderbird"
                else ""
              )

              # control monitors
              "$mainMod, G, split:grabroguewindows"
              "$mainMod, period, focusmonitor, r"
              "$mainMod, comma, focusmonitor, l"
              "$mainMod CONTROL, comma, movewindow, mon:+1"
              "$mainMod CONTROL, period, movewindow, mon:-1"

              # control windows
              "$mainMod, n, movefocus, l"
              "$mainMod, e, movefocus, d"
              "$mainMod, i, movefocus, u"
              "$mainMod, o, movefocus, r"
              "$mainMod CONTROL, n, movewindow, l"
              "$mainMod CONTROL, e, movewindow, d"
              "$mainMod CONTROL, i, movewindow, u"
              "$mainMod CONTROL, o, movewindow, r"
              "$mainMod CONTROL SHIFT, n, swapwindow, l"
              "$mainMod CONTROL SHIFT, e, swapwindow, d"
              "$mainMod CONTROL SHIFT, i, swapwindow, u"
              "$mainMod CONTROL SHIFT, o, swapwindow, r"
              "$mainMod SHIFT, D, killactive,"

              "$mainMod, Tab, cyclenext" # change focus to another window
              "$mainMod, Tab, bringactivetotop" # bring it to the top
            ]
            ++ (
              lib.lists.optional config.common.lockscreen.enable
              "$mainMod CONTROL, Q, exec, pidof hyprlock || hyprlock"
            )
            ++ ( # $mod + [shift] + {1..9} to [move to] workspace {1..9}
              range 1 9
              |> map toString
              |> map (num: [
                "$mainMod, ${num}, split:workspace, ${num}"
                "$mainMod SHIFT, ${num}, split:movetoworkspacesilent, ${num}"
              ])
              |> concatLists
            );

          binde = [
            "$mainMod SHIFT, n, resizeactive, -16  0"
            "$mainMod SHIFT, e, resizeactive,  0   16"
            "$mainMod SHIFT, i, resizeactive,  0  -16"
            "$mainMod SHIFT, o, resizeactive,  16  0"
          ];

          bindm = [
            # Move/resize windows with mainMod + click & drag
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          workspace = [
            "w[tv1],gapsout:0,rounding:0"
          ];

          windowrulev2 = [
            "prop opaque 1 noblur 1, class:(librewolf), title:(Picture-in-Picture)"
            "prop opaque 1 noblur 1, class:(librewolf), title:(.*)(- YouTube)"
            "prop opaque 1 noblur 1, class:(mpv)"
            "suppressevent maximize, class:.*" # From example config, probably important
          ];
        };
      };
    };
}
