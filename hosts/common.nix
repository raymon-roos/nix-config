{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
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
    };
  };

  environment.systemPackages = with pkgs;
    [
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      smartmontools # The smartd service does not install smartctl?
    ];

  services = lib.mkIf pkgs.stdenv.isLinux {
    dbus.implementation = "broker";
    thermald.enable = true;
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
  };

  time.timeZone = "Europe/Amsterdam";

  users.users.ray = {
    shell = pkgs.nushell;
    isNormalUser = true;
    extraGroups = ["wheel" "ray" "video"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ray = import ../home-manager/${config.networking.hostName}/home.nix;
    extraSpecialArgs = with inputs; {inherit nixpkgs inputs;};
  };

  virtualisation.podman = lib.mkIf config.home-manager.users.ray.common.dev.podman.enable {
    enable = true;
    defaultNetwork.settings.dns_enabled = true; # Default bridge network
    autoPrune.enable = true;
    autoPrune.dates = "monthly";
  };

  programs.zsh = {
    enable = true;
    shellInit = ''
      export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    '';
  };

  fonts = {
    packages = with pkgs; [
      fira-code
      nerd-fonts.symbols-only
    ];
  };

  stylix = with lib; {
    enable = true;

    image = lib.mkDefault (pkgs.fetchurl {
      url = "https://images.hdqwalls.com/download/mirrors-edge-4k-xw-1920x1080.jpg";
      sha256 = "1phvbRYaP2vIJqPKfqy1aiduYkBVV6B9pOwgwQw1+Zk=";
    });

    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";

    fonts = {
      sizes.terminal = mkDefault 9;
      sizes.applications = mkDefault 10;

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
