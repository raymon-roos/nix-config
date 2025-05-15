{lib, ...}:
with lib; {
  options.common = {
    hyprland.enable = mkEnableOption "Hyprland & co";
    lockscreen.enable = mkEnableOption "Screenlocker and idle daemon";
  };

  imports = [
    ./hyprland.nix
    ./mako.nix
    ./hypridle.nix
    ./bemenu.nix
    ./hyprlock.nix
  ];
}
