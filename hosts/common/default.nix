{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./watt.nix
  ];

  nix = {
    channel.enable = false;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"]; # used by the nixd LSP
    gc = {
      automatic = true;
      options = "-d --delete-older-than 7d";
    };
    settings = {
      use-xdg-base-directories = true;
      flake-registry = "${inputs.flake-registry}/flake-registry.json";
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  boot = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    zswap.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      smartmontools # The smartd service does not install smartctl?
    ];

  services = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    dbus.implementation = "broker";

    smartd.enable = true;

    xserver = {
      autoRepeatDelay = 130;
      autoRepeatInterval = 15;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    openssh = {
      startWhenNeeded = true;
      settings = {
        PermitRootLogin = "no";
        X11Forwarding = false;
        PasswordAuthentication = false;
      };
    };

    speechd.enable = false;
  };

  time.timeZone = "Europe/Amsterdam";

  users.users.ray = {
    isNormalUser = true;
    extraGroups =
      ["wheel" "ray" "video"]
      ++ lib.optionals config.home-manager.users.ray.common.dev.podman.enable ["podman"]
      ++ lib.optionals config.home-manager.users.ray.common.dev.docker.enable ["docker"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ray = import ../../home-manager/${config.networking.hostName}/home.nix;
    extraSpecialArgs = with inputs; {inherit nixpkgs inputs;};
  };

  virtualisation.podman = lib.mkIf config.home-manager.users.ray.common.dev.podman.enable {
    enable = true;
    defaultNetwork.settings.dns_enabled = true; # Default bridge network
    autoPrune.enable = true;
    autoPrune.dates = "monthly";
    # dockerSocket.enable = true;
  };

  virtualisation.docker = lib.mkIf config.home-manager.users.ray.common.dev.docker.enable {
    enable = true;
    autoPrune.enable = true;
    autoPrune.dates = "monthly";
  };

  programs = let
    shellModules = config.home-manager.users.ray.common.shell;
  in {
    bash = {
      enable = true;
      interactiveShellInit =
        ''[ -f "$XDG_CONFIG_HOME/bash/profile" ] && . "$XDG_CONFIG_HOME/bash/profile" ''
        + lib.optionalString shellModules.nu.enable ''
          # Enter Nushell by default without making it the login shell, because Nu is not posix.
          # Includes an extensive test to see whether entering nu automatically is safe
          if grep -qv 'nu\|nix-shell' /proc/$PPID/comm && [[ $SHLVL == [12] ]] && [ -z "$BASH_EXECUTION_STRING" ] && ! [ "$TERM" = "dumb" ]; then
              SHELL=/run/current-system/sw/bin/nu exec nu
          fi
        '';
    };
    zsh = lib.mkIf shellModules.zsh.enable {
      enable = true;
      shellInit = ''
        export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
      '';
    };

    nushell.enable = shellModules.nu.enable;
  };

  fonts = {
    packages = with pkgs; [
      fira-code
      nerd-fonts.symbols-only
    ];
  };

  stylix = {
    enable = true;

    image = lib.mkDefault (pkgs.fetchurl {
      url = "https://images.hdqwalls.com/download/mirrors-edge-4k-xw-1920x1080.jpg";
      sha256 = "1phvbRYaP2vIJqPKfqy1aiduYkBVV6B9pOwgwQw1+Zk=";
    });

    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";

    fonts = {
      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = config.stylix.fonts.sansSerif;
      emoji.package = pkgs.nerd-fonts.symbols-only;
    };
  };
}
