{
  pkgs,
  config,
  lib,
  ...
}: with lib; {
  options.dev.docker.enable = mkEnableOption "docker & tools";

  config = mkIf config.dev.docker.enable {
    home.sessionVariables = {
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    };

    home = {
      packages = with pkgs; [
      docker
      docker-compose
    ];

    shellAliases = {
      dcu = "docker-compose up -d";
      dcd = "docker-compose down";
    };
  };
};
}
