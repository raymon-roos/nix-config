{
  config,
  pkgs,
  lib,
  ...
}: {
  config.wayland.windowManager.mango.settings = let
    inherit (lib) range zipLists concatMap;

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
  in
    lib.mkIf (
      config.common.wayland.enable
      && config.common.mango.enable
    ) {
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
          "${mod}+SHIFT,F,spawn,agenda_overview.nu"

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

          # control monitors
          "${mod},comma,focusmon,left"
          "${mod},period,focusmon,right"
          "${mod}+CTRL,comma,tagmon,left"
          "${mod}+CTRL,period,tagmon,right"

          "${mod}+SHIFT,n,resizewin,-16,+0"
          "${mod}+SHIFT,e,resizewin,+0,+16"
          "${mod}+SHIFT,i,resizewin,+0,-16"
          "${mod}+SHIFT,o,resizewin,+16,+0"
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
    };
}
