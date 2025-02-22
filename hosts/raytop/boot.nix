{...}: {
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = [];
    };

    kernelModules = [];
    extraModulePackages = [];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        memtest86.enable = true;
      };
    };

    tmp.useTmpfs = true;
  };
}
