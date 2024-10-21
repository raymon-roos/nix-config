{config, ...}: let
  filesHome = "${config.home.homeDirectory}/files";
  xdgHome = "${config.home.homeDirectory}/.xdg";
  cacheHome = "${xdgHome}/cache";
  configHome = "${xdgHome}/config";
  dataHome = "${xdgHome}/local/share";
  stateHome = "${xdgHome}/local/state";
  binHome = "${xdgHome}/local/bin";
  srcHome = "${xdgHome}/local/src";
in {
  config.home.homeDirectory = "/home/${config.home.username}";

  config.xdg = {
    dataHome = dataHome;
    cacheHome = cacheHome;
    stateHome = stateHome;
    configHome = configHome;

    userDirs = {
      enable = true;
      createDirectories = true;
      music = "${filesHome}/music";
      videos = "${filesHome}/videos";
      desktop = "${filesHome}/desktop";
      pictures = "${filesHome}/pictures";
      publicShare = "${filesHome}/shared";
      download = "${filesHome}/downloads";
      templates = "${filesHome}/templates";
      documents = "${filesHome}/documents";
      extraConfig = {
        XDG_HOME = xdgHome;
        BIN_HOME = binHome;
        SRC_HOME = srcHome;
        FILES_HOME = filesHome;
        PROJECTS_HOME = "${config.home.homeDirectory}/projects";
        USB_HOME = "${filesHome}/usb";
        PHONE_HOME = "${filesHome}/phone";
        NOTES_HOME = "${filesHome}/zettelkasten";
        FINANCE_HOME = "${filesHome}/finance";
        DOTREMINDERS = "${filesHome}/reminders";
        PASSWORD_STORE_DIR = "${filesHome}/secrets/passwords";
      };
    };
  };
}
