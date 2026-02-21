{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with lib; let
  # Requires only a single `windowManager` to be enabled, as their ordering is non-deterministic
  loginShellPkg = osConfig.users.users.ray.shell;

  profileExtra = ''
    # autostart compositor of choice when logging in on tty1
    if [ -z "$WAYLAND_DISPLAY" ] && [ $(tty) = "/dev/tty1" ] && [ -z "$(pgrep -i hyprland)" ]; then
        systemd-cat -t compositor start-hyprland
    fi
  '';
in {
  programs = mkIf config.common.wayland.enable {
    bash.profileExtra = mkIf (loginShellPkg == pkgs.bash) profileExtra;
    zsh.profileExtra = mkIf (loginShellPkg == pkgs.zsh) profileExtra;
    nushell.extraLogin = mkIf (loginShellPkg == pkgs.nushell) ''
      # autostart compositor of choice when logging in on tty1
      if ($env.WAYLAND_DISPLAY? | is-empty) and (tty) == "/dev/tty1" and (pgrep -i hyprland | is-empty) {
          systemd-cat -t compositor start-hyprland
      }
    '';
  };
}
