{
  config,
  pkgs,
  ...
}: {
  users.users.ray = {
    shell = pkgs.zsh;
    home = "/Users/ray";
  };

  security.pam.enableSudoTouchIdAuth = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 1w";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
    zsh.enable = true; # further configured in hm config
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment = {
    darwinConfig = ./configuration.nix;

    systemPackages = with pkgs; [
      # curl
      # gcc
      # git
      # gnumake
      # libgcc
      # librewolf
      # unzip
      # wget
    ];

    variables = {
      XDG_CACHE_HOME = "$HOME/.xdg/cache";
      XDG_CONFIG_HOME = "$HOME/.xdg/config";
      XDG_DATA_HOME = "$HOME/.xdg/local/share";
      XDG_STATE_HOME = "$HOME/.xdg/local/state";
    };
  };

  fonts = {
    packages = with pkgs; [
      fira-code
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };

  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [49164 6881];
  #   allowedUDPPorts = [49164 6881];
  # };


    # Used for backwards compatibility, please read the changelog before changing.
    system.stateVersion = 5;
}

