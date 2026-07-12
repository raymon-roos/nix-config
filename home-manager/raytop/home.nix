{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../common
    ./scripts
  ];

  common = {
    librewolf.enable = true;
    librewolf-advanced.enable = true;
    wayland.enable = true;
    hyprland.enable = false;
    mango.enable = true;
    lockscreen.enable = true;
    shell.nu.enable = true;
    email = {
      enable = true;
      accounts = [
        {
          accountName = "personal";
          flavor = "outlook.office365.com";
          primary = true;
        }
        {
          accountName = "fixico";
          flavor = "gmail.com";
        }
        {
          accountName = "gaming";
          flavor = "outlook.office365.com";
        }
        {
          accountName = "gmail";
          flavor = "gmail.com";
        }
      ];
    };
    dev = {
      nix.enable = true;
      nodejs.enable = true;
      php.enable = true;
      rust.enable = true;
      go.enable = true;
      podman.enable = true;
    };
    HUazureDevops.enable = true;
  };

  home = {
    stateVersion = "23.11"; # don't change

    packages = with pkgs; [
      acpi
      brightnessctl
      bzmenu
    ];
  };

  services.mako.settings.border-size = 1;

  programs = {
    librewolf.settings = lib.mkForce {
      "layout.css.devPixelsPerPx" = "0.75"; # shrink ui
    };

    bemenu = lib.mkIf config.common.wayland.enable {
      settings.border = lib.mkForce 1;
    };
  };

  wayland.windowManager = let
    osd =
      pkgs.writers.writeNu "osd.nu"
      (builtins.readFile ./scripts/osd.nu);
  in {
    hyprland = lib.mkIf config.common.hyprland.enable {
      settings = {
        general = {
          gaps_in = 1;
          gaps_out = 2;
        };
        xwayland.force_zero_scaling = true;
        decoration = {
          blur.enabled = false;
          shadow.enabled = false;
        };
        input = {
          kb_layout = "us,us";
          kb_variant = "colemak_dh,intl";
          kb_options = "grp:shift_caps_toggle";
          sensitivity = lib.mkForce 0.8;
        };
        bind = [
          "$mainMod CONTROL, M, exec, pwmenu --launcher custom --launcher-command bemenu -s 2"
          "$mainMod CONTROL, B, exec, bzmenu --launcher custom --launcher-command bemenu -s 2"
        ];
        binde = [
          ", XF86MonBrightnessDown, exec, ${osd} brightness --set '10%-'"
          ", XF86MonBrightnessUp, exec, ${osd} brightness --set '10%+'"
          ", XF86AudioLowerVolume, exec, ${osd} sound set '10%-'"
          ", XF86AudioRaiseVolume, exec, ${osd} sound set '10%+'"
          ", XF86AudioMute, exec, ${osd} sound mute"
          ", XF86AudioMicMute, exec,  ${osd} sound mute --mic=true"
        ];
        gesture = [
          "3, horizontal, workspace"
          "3, up, fullscreen, maximize"
        ];
      };
    };
    mango = lib.mkIf config.common.mango.enable {
      settings = {
        xkb_rules_layout = "us,us";
        xkb_rules_variant = "colemak_dh,intl";
        xkb_rules_options = "grp:shift_caps_toggle";
        trackpad_natural_scrolling = 1;
        trackpad_accel_profile = 1;
        trackpad_accel_speed = 1.25;

        gappih = 1;
        gappiv = 1;
        gappoh = 2;
        gappov = 2;
        blur = 0;
        shadows = 0;
        unfocused_opacity = 0.98;

        border_radius = 4;

        binds = [
          "SUPER+CTRL,M,spawn,pwmenu --launcher custom --launcher-command bemenu -s 2"
          "SUPER+CTRL,B,spawn,bzmenu --launcher custom --launcher-command bemenu -s 2"
        ];

        bind = [
          "NONE,XF86MonBrightnessDown,spawn,${osd} brightness --set '10%-'"
          "NONE,XF86MonBrightnessUp,spawn,${osd} brightness --set '10%+'"
          "NONE,XF86AudioLowerVolume,spawn,${osd} sound set '10%-'"
          "NONE,XF86AudioRaiseVolume,spawn,${osd} sound set '10%+'"
          "NONE,XF86AudioMute,spawn,${osd} sound mute"
          "NONE,XF86AudioMicMute,spawn,${osd} sound mute --mic=true"
        ];

        gesturebind = [
          "NONE,right,3,viewtoleft_have_client"
          "NONE,left,3,viewtoright_have_client"
          "NONE,up,3,toggleoverview,up"
        ];
      };
    };
  };
}
