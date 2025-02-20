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

    zathura = {
      enable = true;
      options = {
        recolor = true;
        sandbox = "strict";
        selection-clipboard = "clipboard";
      };
    };
  };

  wayland.windowManager.hyprland = lib.mkIf config.desktop-config.hyprland.enable {
    settings = {
      input = {
        kb_layout = "us,us";
        kb_variant = "colemak_dh,intl";
        kb_options = "grp:shift_caps_toggle";
      };
    };
  };

  xresources.path = "${config.xdg.configHome}/X11/Xresources";
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
}
