{
  config,
  pkgs,
  lib,
  ...
}: let
  home = "${config.home.homeDirectory}";
  filesHome = "${home}/files";
  xdgHome = "${home}/.xdg";
  cacheHome = "${xdgHome}/cache";
  configHome = "${xdgHome}/config";
  dataHome = "${xdgHome}/local/share";
  stateHome = "${xdgHome}/local/state";
  binHome = "${xdgHome}/local/bin";
  srcHome = "${xdgHome}/local/src";
in {
  home = {
    homeDirectory = "/home/${config.home.username}";

    preferXdgDirectories = true;

    sessionPath = [
      config.xdg.userDirs.extraConfig.BIN_HOME
    ];
  };

  xdg =
    {
      enable = true;
      inherit dataHome cacheHome stateHome configHome;
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
          SCRATCH_HOME = "${home}/scratch";
          FILES_HOME = filesHome;
          PROJECTS_HOME = "${home}/projects";
          USB_HOME = "${filesHome}/usb";
          PHONE_HOME = "${filesHome}/phone";
          NOTES_HOME = "${filesHome}/zettelkasten";
          FINANCE_HOME = "${filesHome}/finance";
        };
      };
    };
}
