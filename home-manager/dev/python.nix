{
  pkgs,
  config,
  ...
}: {
  home.sessionVariables = {
    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
    PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
    PYTHONUSERBASE = "${config.xdg.dataHome}/python";
  };
}
