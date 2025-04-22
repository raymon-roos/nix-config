{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.xdg) configHome;
in {
  programs.nushell = {
    enable = true;

    settings = {
      show_banner = false;
      use_kitty_protocol = config.programs.kitty.enable;
      history.file_format = "sqlite";
      completions.algorithm = "fuzzy";
    };

    shellAliases = {
      ls = lib.mkForce "ls -a";
      fg = "job unfreeze";
      jobs = "job list";
    };

    extraEnv = ''
      $env.PATH = ($env.Path | prepend "${(
        if pkgs.stdenv.isDarwin
        then config.home.sessionVariables.BIN_HOME
        else config.xdg.userDirs.extraConfig.BIN_HOME
      )}")
    '';

    loginFile.text = lib.mkIf config.common.hyprland.enable ''
      # Logging in on tty1, and Hyprland is not yet running
      if (tty) == "/dev/tty1" and (pgrep "Hyprland" | complete).exit_code != 0 {
        Hyprland
      }
    '';
  };
}
