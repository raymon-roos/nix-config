{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./keyd.nix
    ./disko.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 15;
    loader.systemd-boot.memtest86.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.useTmpfs = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "intelephense"
    ];

  hardware = {
    graphics.enable = true;
    graphics.extraPackages = [pkgs.vaapiIntel pkgs.intel-media-driver];
    enableRedistributableFirmware = true;
  };

  networking = {
    hostName = "raytop";
    # wireless.enable = true;
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    useXkbConfig = true;
  };

  services = {
    dbus.implementation = "broker";
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    xserver = {
      autoRepeatDelay = 130;
      autoRepeatInterval = 15;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    openssh = {
      enable = false;
      startWhenNeeded = true;
      hostKeys = [
        {
          comment = "raytop system";
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      settings = {
        PermitRootLogin = "no";
        X11Forwarding = false;
        PasswordAuthentication = false;
      };
    };
  };

  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  users.users.ray = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "ray" "networkmanager" "video"];
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
    nh.flake = "/home/ray/.xdg/config/nix#raytop";

    hyprland.enable = true;
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
    fonts.sizes.terminal = 7;
    fonts.sizes.applications = 8;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 12;
    };
  };

  system.stateVersion = "24.05"; # never ever change this
}
