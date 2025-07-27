{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware
    ./boot.nix
    ./networking.nix
    ./services.nix
    ./keyd.nix
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "intelephense"
      ];
  };

  systemd.sleep.extraConfig = ''
    SuspendState=s2idle
  '';

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    useXkbConfig = true;
  };

  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  users.users.ray = {
    extraGroups = ["networkmanager"];
  };

  nix.settings = {
    auto-optimise-store = true;
  };

  programs = let
    hmConfig = config.home-manager.users.ray.common;
  in {
    nix-ld.enable = true; # hack to fix dynamically linked binaries for traditional distros

    hyprland.enable = hmConfig.hyprland.enable;
  };

  environment = {
    systemPackages = with pkgs; [
      #
    ];

    variables = {
      NIXOS_OZONE_WL = 1; # Avoid Xwayland for electron apps
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.xdg/cache";
      XDG_CONFIG_HOME = "$HOME/.xdg/config";
      XDG_DATA_HOME = "$HOME/.xdg/local/share";
      XDG_STATE_HOME = "$HOME/.xdg/local/state";
    };
  };

  fonts.enableDefaultPackages = true;

  stylix = {
    fonts = {
      sizes.terminal = 6;
      sizes.applications = 8;
      sizes.popups = 7;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 12;
    };
  };

  system.stateVersion = "24.05"; # never ever change this
}
