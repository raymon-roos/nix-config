{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; {
  options.plover.enable = mkEnableOption "Plover steno engine appimage community flake";

  config = mkIf config.plover.enable {
    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';

    programs = {
      appimage.enable = true;
      appimage.binfmt = true;
    };

    users.users.ray.extraGroups = ["input"];

    environment.systemPackages = [
      (inputs.plover-flake.packages.${stdenv.hostPlatform.system}.plover.with-plugins (
        ps:
          with ps; [
            # plover-console-ui
          ]
      ))
    ];
  };
}
