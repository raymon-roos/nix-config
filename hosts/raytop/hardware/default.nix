{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix") # from `nixos-generate-config`
    ./disko.nix
  ];

  powerManagement.enable = true;

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    graphics.enable = true;
    graphics.extraPackages = [pkgs.intel-vaapi-driver pkgs.intel-media-driver];
    enableRedistributableFirmware = true;
  };
}
