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
    librewolf-advanced.enable = false;
    lockscreen.enable = true;
    hyprland.enable = true;
  };
  dev = {
    nix.enable = true;
    nodejs.enable = true;
    php.enable = true;
    rust.enable = true;
  };
  HUazureDevops.enable = true;

  home = {
    stateVersion = "23.11"; # don't change

    packages = with pkgs; [
      acpi
      brightnessctl
    ];
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  programs = let
    contact_info = import "${inputs.secrets}/contact_info.nix";
  in {
    git.userEmail = contact_info.personal.address;

    librewolf.settings = lib.mkForce {
      "layout.css.devPixelsPerPx" = "1.0"; # shrink ui
    };

    bemenu = lib.mkIf config.common.hyprland.enable {
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
      decoration = {
        blur.enabled = false;
        shadow.enabled = false;
      };
      input = {
        kb_layout = "us,us";
        kb_variant = "colemak_dh,intl";
        kb_options = "grp:shift_caps_toggle";
      };
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
