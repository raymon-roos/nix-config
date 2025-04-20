{
  pkgs,
  config,
  lib,
  ...
}: let
  home = "${config.home.homeDirectory}";
  xdgHome = "${config.home.homeDirectory}/.xdg";
  binHome = "${xdgHome}/local/bin";
  srcHome = "${xdgHome}/local/src";
in {
  home.sessionVariables =
    {
      BROWSER = "librewolf";
      TERMINAL = "kitty";
      MANPAGER = "nvim +Man!";
      MANWIDTH = 90;

      FLAKE = "${config.xdg.configHome}/nix";
      ADB_KEYS_PATH = "${config.xdg.configHome}/android";
      CALCHISTFILE = "${config.xdg.stateHome}/calc/calc_history";
      IMAPFILTER_HOME = "${config.xdg.configHome}/imapfilter";
      LESSHISTFILE = "${config.xdg.stateHome}/less/lesshst";
      LYNX_CFG_PATH = "${config.xdg.configHome}/lynx/lynx.cfg";
      MYSQL_HISTFILE = "${config.xdg.stateHome}/mysql/mysql_history";
      NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/config";
      TEXMFCONFIG = "${config.xdg.configHome}/texlive/texmf-config";
      TEXMFHOME = "${config.xdg.dataHome}/texmf";
      TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
      WGETRC = "${config.xdg.configHome}/wget/wgetrc";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      # Hack to get dynamically linked binaries for traditional distros working on NixOS
      NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      # on aarch64_darwin, there's no home.xdg.userDirs.extraConfig, so these variables are added explicitely
      XDG_HOME = xdgHome;
      BIN_HOME = binHome;
      SRC_HOME = srcHome;
      FILES_HOME = home;
      PROJECTS_HOME = "${home}/projects";
    };
}
