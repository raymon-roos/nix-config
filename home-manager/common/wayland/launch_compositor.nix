{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with lib; let
  # Requires only a single `windowManager` to be enabled, as their ordering is non-deterministic
  windowManager =
    config.wayland.windowManager
    |> attrsToList
    |> filter (w: w.value.enable)
    |> map (w: w.name)
    |> head;

  loginShellPkg = osConfig.users.users.ray.shell;

  profileExtra = ''
    # autostart compositor of choice when logging in on tty1
    if [ -z "$WAYLAND_DISPLAY" ] && [ $(tty) = "/dev/tty1" ] && [ -z "$(pgrep -i ${windowManager})" ]; then
        ${windowManager} 2>&1 | tee /tmp/${windowManager}.log
    fi
  '';
in {
  programs = mkIf config.common.wayland.enable {
    bash.profileExtra = mkIf (loginShellPkg == pkgs.bash) profileExtra;
    zsh.profileExtra = mkIf (loginShellPkg == pkgs.zsh) profileExtra;
    nushell.extraLogin = mkIf (loginShellPkg == pkgs.nushell) ''
      # autostart compositor of choice when logging in on tty1
      if ($env.WAYLAND_DISPLAY? | is-empty) and (tty) == "/dev/tty1" and (pgrep -i ${windowManager} | is-empty) {
          ${windowManager} out+err>| tee { save -f /tmp/${windowManager}.log }
      }
    '';
  };
}
