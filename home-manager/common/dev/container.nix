{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.dev.docker.enable = mkEnableOption "docker & tools";
  options.common.dev.podman.enable = mkEnableOption "podman & tools - a daemonless/rootless docker alternative";

  config.home =
    {}
    // mkIf config.common.dev.docker.enable {
      sessionVariables = {
        DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      };

      packages = with pkgs; [
        docker
        docker-compose
      ];

      shellAliases = {
        dcu = "docker-compose up -d";
        dcd = "docker-compose down";
      };
    }
    // mkIf config.common.dev.podman.enable {
      packages = [pkgs.podman-compose];

      shellAliases = {
        dcu = "podman-compose up -d";
        dcd = "podman-compose down";
      };
    };
}
