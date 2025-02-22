{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix") # from `nixos-generate-config`
    ../common.nix
    ./hardware
    ./networking.nix
    ./services.nix
    ./plover.nix
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "nvidia-x11"
        "intelephense"
      ];
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  plover.enable = false;

  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  users.users.ray = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "ray" "video"];
  };

  nix.settings = {
    auto-optimise-store = true;
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
    };

    nix-ld.enable = true; # hack to fix dynamically linked binaries for traditional distros

    nh.enable = true;
    nh.flake = "/home/ray/.xdg/config/nix";

    hyprland = {
      enable = true;
    };
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
