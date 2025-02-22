{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nix = {
    channel.enable = false;
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

  users.users.ray =
    {
      shell = pkgs.zsh;
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      isNormalUser = true;
      extraGroups = ["wheel" "ray" "video"];
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      home = /Users/ray;
    };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ray = import ../home-manager/${config.networking.hostName}/home.nix;
    extraSpecialArgs = with inputs; {inherit nixpkgs inputs;};
  };

  programs.zsh.enable = true;

  fonts = {
    packages = with pkgs; [
      fira-code
      nerd-fonts.symbols-only
    ];
  };

  stylix = with lib; {
    enable = true;

    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/images6/Berserk-Wide-Screen-Wallpaper.jpg";
      sha256 = "dNDr1bOiOOo8NSNoIvg1VXYaUTZr1Dg1x0J4BMP2fzg=";
    };

    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";

    fonts = {
      sizes.terminal = mkDefault 9;
      sizes.applications = mkDefault 11;

      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = config.stylix.fonts.sansSerif;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
