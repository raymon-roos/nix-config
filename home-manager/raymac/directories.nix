let
  home = "/Users/ray";
  xdgHome = "${home}/.xdg";
  cacheHome = "${xdgHome}/cache";
  configHome = "${xdgHome}/config";
  dataHome = "${xdgHome}/local/share";
  stateHome = "${xdgHome}/local/state";
  binHome = "${xdgHome}/local/bin";
  srcHome = "${xdgHome}/local/src";
in {
    userDirs = {
      music = "${home}/Music";
      videos = "${home}/Videos";
      desktop = "${home}/Desktop";
      pictures = "${home}/Pictures";
      publicShare = "${home}/Shared";
      download = "${home}/Downloads";
      templates = "${home}/Templates";
      documents = "${home}/Documents";
      extraConfig = {
        XDG_HOME = xdgHome;
        BIN_HOME = binHome;
        SRC_HOME = srcHome;
        FILES_HOME = home;
        PROJECTS_HOME = "${home}/projects";
        USB_HOME = "${home}/usb";
        PHONE_HOME = "${home}/phone";
        NOTES_HOME = "${home}/zettelkasten";
        FINANCE_HOME = "${home}/finance";
        DOTREMINDERS = "${home}/reminders";
        PASSWORD_STORE_DIR = "${home}/secrets/passwords";
      };
    };
}

