{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../common
    ./shell.nix
  ];

  common.librewolf.enable = true;
  desktop-config.lockscreen.enable = true;
  desktop-config.hyprland.enable = true;
  dev.nix.enable = true;
  dev.nodejs.enable = true;
  dev.php.enable = true;
  dev.rust.enable = true;
  HUazureDevops.enable = true;

  home = {
    stateVersion = "23.11"; # don't change

    username = "ray";

    sessionPath = [
      config.xdg.userDirs.extraConfig.BIN_HOME
    ];

    packages = with pkgs; [
      acpi
      brightnessctl
      keychain
      remind
      thunderbird
      vesktop
      wl-clipboard-rs
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

    zathura = {
      enable = true;
      options = {
        recolor = true;
        sandbox = "strict";
        selection-clipboard = "clipboard";
      };
    };
  };

  stylix = {
    targets.bemenu.fontSize = 8;
  };

  wayland.windowManager.hyprland = lib.mkIf config.desktop-config.hyprland.enable {
    settings = {
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

  xresources.path = "${config.xdg.configHome}/X11/Xresources";
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
}
