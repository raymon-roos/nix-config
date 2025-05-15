{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../common
    ./shell.nix
    ./desktop.nix
  ];

  common = {
    librewolf.enable = true;
    librewolf-advanced.enable = false;
    lockscreen.enable = true;
    hyprland.enable = true;
  };
  dev = {
    nix.enable = true;
    nodejs.enable = true;
    php.enable = true;
    rust.enable = true;
  };
  HUazureDevops.enable = true;

  home = {
    stateVersion = "23.11"; # don't change

    packages = with pkgs; [
      acpi
      brightnessctl
    ];
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  programs = let
    contact_info = import "${inputs.secrets}/contact_info.nix";
  in {
    git.userEmail = contact_info.personal.address;
  };
}
