{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services = lib.mkIf pkgs.stdenv.isLinux {
    watt = {
      enable = true;
      package = inputs.watt.packages.${pkgs.stdenv.hostPlatform.system}.watt;
    };
  };

  systemd.services.watt = lib.mkIf config.services.watt.enable {
    environment.WATT_CONFIG = ./watt.toml;

    serviceConfig.ExecStart = lib.mkForce "${lib.getExe config.services.watt.package} -q";
  };
}
