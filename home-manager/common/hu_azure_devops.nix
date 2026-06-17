{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.HUazureDevops.enable =
    mkEnableOption
    ''
      Workaround to automatically associate secondary SSH key with certain
      remote hosts I use at my study.
    '';

  config = mkIf config.common.HUazureDevops.enable {
    programs = {
      git.settings = {
        url."git@hu.ssh.dev.azure.com".insteadOf = ["git@ssh.dev.azure.com"];
      };

      ssh.settings."hu.ssh.dev.azure.com" = {
        HostName = "ssh.dev.azure.com";
        IdentityFile = "~/.ssh/id_rsa_hu_azure_devops";
      };
    };
  };
}
