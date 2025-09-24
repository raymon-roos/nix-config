{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.common.river.enable = mkEnableOption "river compositor for wayland";

  config =
    mkIf (
      config.common.wayland.enable
      && config.common.river.enable
    ) {
      wayland.windowManager.river = let
        layout = "rivercarro";
      in {
        enable = true;
        settings = {
          default-attach-mode = "below";
          hide-cursor = "when-typing enabled";
          set-cursor-warp = "on-focus-change";
          set-repeat = "50 130";
          border-width = 1;
          input = {
            "pointer-*" = {
              accel-profile = "flat";
              pointer-accel = 0;
            };
          };
          rule-add = {
            "-app-id" = {
              "*" = "ssd";
            };
          };
          spawn = let
            colors = config.lib.stylix.colors;
            alpha = a:
              lib.toHexString (
                ((builtins.ceil (a * 100)) * 255) / 100
              );
            rgb = color: "0x${color}";
            rgba = color: a: "0x${color}${alpha a}";
          in [
            "'pkill -15 wbg; wbg ${config.stylix.image} &'"
            "'pkill -15 mako; mako &'"
            "'pkill -15 river-tag; river-tag-overlay ${cli.toGNUCommandLineShell {} {
              anchor = "1:1:0:1";
              margin = "5:0:0:0";
              square-size = 15;
              square-padding = 3;
              square-inner-padding = 2;
              border-width = 1;
              square-border-width = 0;
              background-colour = rgba colors.base01 95;
              border-colour = rgb colors.base00;
              square-active-background-colour = rgb colors.base0D;
              square-active-occupied-colour = rgb colors.base0C;
              square-inactive-background-colour = rgb colors.base02;
              square-inactive-occupied-colour = rgb colors.base04;
              square-urgent-background-colour = rgb colors.base08;
              square-urgent-occupied-colour = rgb colors.base09;
            }} &'"
          ];
          declare-mode = ["normal"];
          map = let
            pow = e:
              if e != 0
              then 2 * (pow (e - 1))
              else 1;
            # River uses a 32 bit mask to declare tags
            allTags = (pow 32) - 1;
          in {
            normal =
              {
                "Super+Control+Shift Q" = "exit";
                "Super Semicolon" = "spawn bemenu-run";
                "Super+Shift Semicolon" = "spawn passmenu_custom";
                "Super Return" = "spawn kitty";
                "Super Z" = "spawn librewolf";
                "Super K" = "spawn 'kitty --hold aerc'";
                "Super+Shift B" = "spawn 'kitty --hold btm --default_widget_type=processes --expanded'";
                "Super P" = "spawn directories_bemenu.sh";

                "Super+Control C" = "spawn 'cmus-remote -u || kitty --class cmus cmus'";
                "Super+Control B" = "spawn 'cmus-remote -n'";
                "Super+Control Z" = "spawn 'cmus-remote -r'";
                "Super+Control M" = ''spawn "cmus-remote -C 'toggle aaa_mode'"'';

                "Super L" = "spawn 'makoctl dismiss'";
                "Super U" = "spawn 'makoctl menu bemenu --accept-single'";
                "Super Y" = "spawn 'makoctl restore'";

                "Super+Shift D" = "close";
                "Super V" = "toggle-float";
                "None F11" = "toggle-fullscreen";
                "Super H" = "send-layout-cmd ${layout} 'main-location-cycle left,monocle'";
                "Super Plus" = "send-layout-cmd ${layout} 'main-count +1'";
                "Super Minus" = "send-layout-cmd ${layout} 'main-count -1'";
                "Super space" = "zoom";

                "Super N" = "focus-view left";
                "Super E" = "focus-view down";
                "Super I" = "focus-view up";
                "Super O" = "focus-view right";
                "Super+Control N" = "swap left";
                "Super+Control E" = "swap down";
                "Super+Control I" = "swap up";
                "Super+Control O" = "swap right";

                "Super 0" = "set-focused-tags ${toString allTags}";
                "Super+Shift 0" = "set-view-tags ${toString allTags}";
                "Super Tab" = "focus-previous-tags";

                "Super Period" = "focus-output right";
                "Super Comma" = "focus-output left";
                "Super+Control Period" = "send-to-output right";
                "Super+Control Comma" = "send-to-output left";
              }
              // (
                range 1 9
                |> map (i: let
                  num = toString i;
                  tags = pow (i - 1) |> toString;
                in {
                  "Super ${num}" = "set-focused-tags ${tags}";
                  "Super+Shift ${num}" = "set-view-tags ${tags}";
                  "Super+Control ${num}" = "toggle-focused-tags ${tags}";
                  "Super+Shift+Control ${num}" = "toggle-view-tags ${tags}";
                })
                |> mergeAttrsList
              )
              // optionalAttrs config.common.lockscreen.enable {
                "Super+Control Q" = "spawn 'pidof hyprlock || hyprlock'";
              };

            "-repeat normal" = {
              "Super+Shift N" = "send-layout-cmd ${layout} 'main-ratio -0.017'";
              "Super+Shift O" = "send-layout-cmd ${layout} 'main-ratio +0.017'";
            };
          };
          map-pointer = {
            normal = {
              "Super BTN_LEFT" = "move-view";
              "Super BTN_RIGHT" = "resize-view";
              "Super BTN_MIDDLE" = "toggle-float";
            };
          };
        };
        extraConfig = ''
          riverctl default-layout ${layout}
          ${layout} \
              -main-ratio 0.5 \
              -outer-gaps 3 \
              -inner-gaps 2 \
              -per-tag \
              >"/tmp/${layout}.$USER.log" 2>&1 &
        '';
      };

      home.packages = with pkgs; [
        river-tag-overlay
        rivercarro
        wbg
        wlr-randr
      ];
    };
}
