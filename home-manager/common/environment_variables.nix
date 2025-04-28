{
  pkgs,
  config,
  lib,
  ...
}: let
  home = "${config.home.homeDirectory}";
  xdgHome = "${home}/.xdg";
  binHome = "${xdgHome}/local/bin";
  srcHome = "${xdgHome}/local/src";
  inherit (config.xdg) cacheHome configHome dataHome stateHome;
in {
  home.sessionVariables =
    {
      BROWSER = "librewolf";
      TERMINAL = "kitty";
      MANPAGER = "nvim '+Man!'";
      MANWIDTH = 90;

      ADB_KEYS_PATH = "${configHome}/android";
      CALCHISTFILE = "${stateHome}/calc/calc_history";
      IMAPFILTER_HOME = "${configHome}/imapfilter";
      LESSHISTFILE = "${stateHome}/less/lesshst";
      LYNX_CFG_PATH = "${configHome}/lynx/lynx.cfg";
      MYSQL_HISTFILE = "${stateHome}/mysql/mysql_history";
      NOTMUCH_CONFIG = "${configHome}/notmuch/config";
      TEXMFCONFIG = "${configHome}/texlive/texmf-config";
      TEXMFHOME = "${dataHome}/texmf";
      TEXMFVAR = "${cacheHome}/texlive/texmf-var";
      WGETRC = "${configHome}/wget/wgetrc";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      # Hack to get dynamically linked binaries for traditional distros working on NixOS
      NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
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
