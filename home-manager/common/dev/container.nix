{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.dev.docker.enable = mkEnableOption "docker & tools";
  options.common.dev.podman.enable = mkEnableOption "podman & tools - a daemonless/rootless docker alternative";

  config.home = let
    aliases = cmd:
      builtins.mapAttrs (alias: value: cmd + " " + value) {
        dcu = "up -d";
        dcd = "down";
        dcp = "ps";
        dct = "stats";
        dcl = "logs";
      };
  in
    {}
    // mkIf config.common.dev.docker.enable {
      sessionVariables = {
        DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      };

      packages = with pkgs; [
        docker
        docker-compose
      ];

      shellAliases = aliases "docker-compose";
    }
    // mkIf config.common.dev.podman.enable {
      packages = [pkgs.podman-compose];

      shellAliases = aliases "podman-compose";
    };
}
