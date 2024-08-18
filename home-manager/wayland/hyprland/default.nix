{pkgs, ...} @ inputs: {
  programs.hyprland.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
    ];
  };
}
