{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.HUazureDevops.enable =
    mkEnableOption
    ''
      Workaround to automatically associate secondary SSH key with certain
      remote hosts I use at my study.
    '';

  config = mkIf config.HUazureDevops.enable {
    programs = {
      git.extraConfig = {
        url."git@hu.ssh.dev.azure.com".insteadOf = ["git@ssh.dev.azure.com"];
      };

      ssh.matchBlocks."hu.ssh.dev.azure.com" = {
        hostname = "ssh.dev.azure.com";
        identityFile = "~/.ssh/id_rsa_hu_azure_devops";
      };
    };
  };
}
