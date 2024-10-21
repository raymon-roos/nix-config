{
  pkgs,
  config,
  ...
}: {
  home.sessionVariables = {
    npm_config_userconfig = "${config.xdg.configHome}/npm/npmrc";
    npm_config_cache = "${config.xdg.cacheHome}/npm/";
  };

  home.packages = with pkgs; [
    nodejs_22
    # nodePackages.npm
  ];

  xdg.configFile."npm/npmrc".text = ''
    prefix=${config.xdg.dataHome}/npm
    cache=${config.xdg.cacheHome}/npm
    init-module=${config.xdg.configHome}/npm/config/npm-init.js
    logs-dir=${config.xdg.stateHome}/npm/logs
  '';
}
