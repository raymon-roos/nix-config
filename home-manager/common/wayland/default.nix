{lib, ...}:
with lib; {
  options.common = {
    wayland.enable = mkEnableOption "wayland display server & tools";
    hyprland.enable = mkEnableOption "Hyprland & co";
    lockscreen.enable = mkEnableOption "Screenlocker and idle daemon";
  };

  imports = [
    ./launch_compositor.nix
    ./hyprland.nix
    ./river.nix
    ./mako.nix
    ./hypridle.nix
    ./bemenu.nix
    ./hyprlock.nix
  ];
}
