{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Reference https://mailtrap.io/blog/starttls-ssl-tls/
  # home-manager has good defaults, but just to make sure it stays this way
  tls = {
    enable = true; # Use encrypted connection to mail server
    useStartTls = false; # Don't negotiate, just do it
  };
in {
  imports = [
    # ./thunderbird
    ./accounts/personal.nix
    ./accounts/gmail.nix
  ];

  home.packages = [
    inputs.himalaya.packages.${pkgs.system}.default
  ];

  programs = {
    mbsync = {
      enable = false;
    };
    himalaya = {
      enable = true;
      package = inputs.himalaya.packages.${pkgs.system}.default;
      settings = {
        downloads-dir = config.xdg.userDirs.download;
      };
    };
  };

  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";
  };
}
