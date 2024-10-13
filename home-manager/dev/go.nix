{
  pkgs,
  config,
  ...
}: {
  programs.go = {
    enable = true;
    goBin = config.xdg.userDirs.extraConfig.BIN_HOME;
    goPath = ".xdg/local/share/go";
  };

  home.packages = with pkgs; [
    gopls
    revive
  ];
}
