{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.dev.php.enable = mkEnableOption "PHP dev tools";

  config = mkIf config.common.dev.php.enable {
    # home.sessionVariables = {
    #   COMPOSER_CACHE_DIR = "${config.xdg.cacheHome}/composer";
    #   COMPOSER_HOME = "${config.xdg.dataHome}/composer";
    # };

    home.packages = with pkgs; [
      php84
      # php84Packages.composer
      # php84Packages.php-cs-fixer
      intelephense
      # phpactor
      # php84Packages.php-codesniffer
    ];

    # xdg.configFile."composer/config.json".text = builtins.toJSON {
    #   repositories = [
    #     {
    #       type = "composer";
    #       url = "https://fixico.repo.repman.io";
    #     }
    #   ];
    # };
  };
}
