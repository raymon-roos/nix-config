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
    hyprland.enable = true;
    lockscreen.enable = true;
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
    ];
  };

  services.mako.settings.border-size = 1;

  programs = {
    librewolf.settings = lib.mkForce {
      "layout.css.devPixelsPerPx" = "1.0"; # shrink ui
    };

    bemenu = lib.mkIf config.common.wayland.enable {
      settings.border = lib.mkForce 1;
    };
  };

  stylix = {
    targets.bemenu.fontSize = 6;
  };

  wayland.windowManager.hyprland = lib.mkIf config.common.hyprland.enable {
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
        "$mainMod CONTROL, M, exec, set_volume.sh"
      ];
      binde = [
        ", XF86MonBrightnessDown, exec, brightnessctl set '10%-' --min-value 10"
        ", XF86MonBrightnessUp, exec, brightnessctl set '10%+'"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ '5%-'"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ '5%+'"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
      ];
    };
  };
}
