{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware
    ./networking.nix
    ./services.nix
    ./plover.nix
  ];

  plover.enable = false;

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  nix.settings = {
    auto-optimise-store = true;
  };

  users.users.ray.shell = pkgs.nushell;

  programs = {
    nix-ld.enable = true; # hack to fix dynamically linked binaries for traditional distros

    hyprland = {
      enable = true;
    };
    river = {
      enable = true; # Enabled here for desktop-portal integration
      package = null; # Let home-manager install package
      extraPackages = [];
    };
    maomaowm.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      #
    ];

    variables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
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
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
  };

  system.stateVersion = "24.05"; # never ever change this
}
