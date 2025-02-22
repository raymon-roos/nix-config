{...}: {
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = [];
    };

    # partition inside luks holding the swapfile
    resumeDevice = "/dev/disk/by-uuid/55373f29-5699-46ed-9de0-644f3a377c8c";
    # sudo btrfs inspect-internal map-swapfile -r /.swap/swapfile
    kernelParams = ["resume_offset=533760"];

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
