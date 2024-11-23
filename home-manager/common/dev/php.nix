{
  pkgs,
  config,
  lib,
  ...
}: with lib; {
  options.dev.php.enable = mkEnableOption "PHP dev tools";

  config = mkIf config.dev.php.enable {
    # home.sessionVariables = {
    #   COMPOSER_CACHE_DIR = "${config.xdg.cacheHome}/composer";
    #   COMPOSER_HOME = "${config.xdg.dataHome}/composer";
    # };

    home.packages = with pkgs; [
      php83
      php83Packages.composer
    ];

    xdg.configFile."composer/config.json".text = builtins.toJSON {
      repositories = [
        {
          type = "composer";
          url = "https://fixico.repo.repman.io";
        }
      ];
    };
  };
}
