{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 15;
    loader.efi.canTouchEfiVariables = true;
    tmp.useTmpfs = true;
  };

  fileSystems = {
    "/boot".options = ["fmask=0077" "dmask=0077"];
    "/".options = ["subvol=nixos" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/root".options = ["subvol=home_root" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/nix".options = ["subvol=nix" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/opt".options = ["subvol=opt" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/srv".options = ["subvol=srv" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/usr/local".options = ["subvol=usr/local" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/var".options = ["subvol=var" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/snapshots".options = ["subvol=snapshots" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/home/ray".options = ["subvol=home_ray" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    "/home/ray/files/2-disk".options = ["defaults" "rw" "noatime" "compress-force=zstd:5"];
    "/mnt/artix".options = ["defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  networking.hostName = "raydesk";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  services = {
    xserver = {
      videoDrivers = ["nvidia"];
      autoRepeatDelay = 130;
      autoRepeatInterval = 15;
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  users.users.ray = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "ray" "video"];
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    zsh.enable = true; # further configured in hm config
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
    nh.flake = "/home/ray/.xdg/config/nix#raydesk";
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      gcc
      git
      gnumake
      libgcc
      libnotify
      librewolf
      unzip
      wget
      wl-clipboard-rs
    ];

    variables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      XDG_CACHE_HOME = "$HOME/.xdg/cache";
      XDG_CONFIG_HOME = "$HOME/.xdg/config";
      XDG_DATA_HOME = "$HOME/.xdg/local/share";
      XDG_STATE_HOME = "$HOME/.xdg/local/state";
    };

    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.xdg/cache";
      XDG_CONFIG_HOME = "$HOME/.xdg/config";
      XDG_DATA_HOME = "$HOME/.xdg/local/share";
      XDG_STATE_HOME = "$HOME/.xdg/local/state";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # never ever change this
}
