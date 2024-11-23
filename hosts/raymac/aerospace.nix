{
  config,
  pkgs,
  ...
}: {
  services.aerospace = {
      enable = true;
      settings = {
        # Default config values: https://nikitabobko.github.io/AeroSpace/guide#default-config
        on-focus-changed = ["move-mouse window-lazy-center"];
        automatically-unhide-macos-hidden-apps = true;
        workspace-to-monitor-force-assignment = {
            "1" = "secondary";
            "2" = "secondary";
            "3" = "secondary";
            "4" = "secondary";
        };
        mode = {
          main.binding = {
            cmd-shift-enter = "exec-and-forget open -n -a kitty --args --config $XDG_CONFIG_HOME/kitty/kitty.conf -1";
            cmd-z = "exec-and-forget open -n -a librewolf";

            cmd-shift-slash  = "layout tiles horizontal vertical";
            cmd-shift-y  = "layout accordion horizontal vertical";

            cmd-n  = "focus left";
            cmd-e  = "focus down";
            cmd-i  = "focus up";
            cmd-o  = "focus right";

            cmd-ctrl-n  = "move left";
            cmd-ctrl-e  = "move down";
            cmd-ctrl-i  = "move up";
            cmd-ctrl-o  = "move right";

            cmd-alt-n  = "join-with left";
            cmd-alt-e  = "join-with down";
            cmd-alt-i  = "join-with up";
            cmd-alt-o  = "join-with right";

            cmd-shift-e  = "resize smart -40";
            cmd-shift-i  = "resize smart +40";

            cmd-h  = "fullscreen";
            cmd-m = []; # Disable macos "hide window" on colemak_dh
            cmd-alt-m = []; # Disable macos "hide other windows" on colemak_dh

            cmd-tab  = "workspace-back-and-forth";

            cmd-comma  = "focus-monitor --wrap-around prev";
            cmd-period  = "focus-monitor --wrap-around next";

            cmd-shift-comma  = "move-node-to-monitor --wrap-around prev";
            cmd-shift-period  = "move-node-to-monitor --wrap-around next";

            cmd-ctrl-comma  = "move-workspace-to-monitor --wrap-around prev";
            cmd-ctrl-period  = "move-workspace-to-monitor --wrap-around next";
          }
          // builtins.listToAttrs (
               builtins.concatLists (builtins.genList (i: [
                 { name = "cmd-${toString (i + 1)}"; value = "workspace ${toString (i + 1)}"; }
                 { name = "cmd-shift-${toString (i + 1)}"; value = "move-node-to-workspace ${toString (i + 1)}"; }
               ]) 9)
             );
        };
      };
    };

}
