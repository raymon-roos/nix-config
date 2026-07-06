{
  pkgs,
  modulesPath,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  # https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD

  imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];

  isoImage.squashfsCompression = "gzip";

  nixpkgs.hostPlatform = system;

  nix = {
    channel.enable = false;
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true; # use xkb.options in tty.

  environment.systemPackages = with pkgs; [
    git
    neovim
    openssh
    inputs.disko.packages.${system}.disko
  ];

  services = {
    xserver.xkb = {
      layout = "us";
      variant = "colemak_dh";
    };

    openssh.enable = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABNctmwmnrWd4Au9ZCw/FqRp+JHbKjlVTPDWeLIm2Ha ray@raydesk"
  ];

  system.stateVersion = "24.05";

  networking.networkmanager.enable = true;
}
