{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.dev.go.enable = mkEnableOption "Go dev tools";

  config = mkIf config.common.dev.go.enable {
    programs.go = {
      enable = true;
      telemetry.mode = "off";
      env = {
        GOPATH = ["${config.xdg.dataHome}/go"];
        GOBIN = "${config.xdg.userDirs.extraConfig.BIN_HOME}";
      };
    };

    home.packages = with pkgs; [
      gopls
      revive
      gofumpt
      golangci-lint
      air
    ];
  };
}
