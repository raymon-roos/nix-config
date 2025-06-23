{config, ...}: let
  inherit (config.xdg) cacheHome configHome dataHome stateHome;
in {
  home.sessionVariables = {
    EDITOR = "nvim";
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
  };
}
