{
  config,
  lib,
  ...
}:
with lib; {
  options.common.rtorrent.enable = mkEnableOption "rtorrent, the ncurses bittorrent client";

  config = mkIf config.common.rtorrent.enable {
    programs.rtorrent.enable = true;
    xdg.configFile."rtorrent/rtorrent.rc".source = ./rtorrent.rc;
  };
}
