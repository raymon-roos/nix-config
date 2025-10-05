{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.dev.python.enable = mkEnableOption "Python dev tools";

  config = mkIf config.common.dev.python.enable {
    home.sessionVariables = {
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
      PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
      PYTHONUSERBASE = "${config.xdg.dataHome}/python";
    };
  };
}
