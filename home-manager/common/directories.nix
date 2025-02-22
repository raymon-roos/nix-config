{
  config,
  pkgs,
  lib,
  ...
}: let
  filesHome = "${config.home.homeDirectory}/files";
  xdgHome = "${config.home.homeDirectory}/.xdg";
  cacheHome = "${xdgHome}/cache";
  configHome = "${xdgHome}/config";
  dataHome = "${xdgHome}/local/share";
  stateHome = "${xdgHome}/local/state";
  binHome = "${xdgHome}/local/bin";
  srcHome = "${xdgHome}/local/src";
in {
  home.homeDirectory =
    (
      if pkgs.stdenv.isDarwin
      then /Users
      else "/home"
    )
    + "/${config.home.username}";
  home.preferXdgDirectories = true;

  xdg =
    {
      enable = true;
      dataHome = dataHome;
      cacheHome = cacheHome;
      stateHome = stateHome;
      configHome = configHome;
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
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
        };
      };
    };
}
