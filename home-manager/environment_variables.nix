{config, ...}: {
  home.sessionVariables = {
    BROWSER = "librewolf";
    TERMINAL = "kitty";
    MANPAGER = "nvim +Man!";
    MANWIDTH = 90;
    PASSWORD_STORE_CLIP_TIME = 30;
    PASSWORD_STORE_ENABLE_EXTENSIONS = "true";

    FLAKE = "${config.xdg.configHome}/nix";
    ADB_KEYS_PATH = "${config.xdg.configHome}/android";
    CALCHISTFILE = "${config.xdg.stateHome}/calc/calc_history";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    GOBIN = "${config.xdg.userDirs.extraConfig.XDG_HOME}/local/bin";
    GOMODCACHE = "${config.xdg.cacheHome}/go/pkg/mod";
    GOPATH = "${config.xdg.userDirs.extraConfig.PROJECTS_HOME}/go";
    IMAPFILTER_HOME = "${config.xdg.configHome}/imapfilter";
    INPUTRC = "${config.xdg.configHome}/readline/inputrc";
    LESSHISTFILE = "${config.xdg.stateHome}/less/lesshst";
    LYNX_CFG_PATH = "${config.xdg.configHome}/lynx/lynx.cfg";
    MYSQL_HISTFILE = "${config.xdg.stateHome}/mysql/mysql_history";
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/node_repl_history";
    NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/config";
    TEXMFCONFIG = "${config.xdg.configHome}/texlive/texmf-config";
    TEXMFHOME = "${config.xdg.dataHome}/texmf";
    TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
    WGETRC = "${config.xdg.configHome}/wget/wgetrc";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
  };
}
