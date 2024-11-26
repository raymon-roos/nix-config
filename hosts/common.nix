{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      options = "-d --delete-older-than 7d";
    };
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
