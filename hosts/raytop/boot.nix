{...}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
      kernelModules = [];
    };

    # partition inside luks holding the swapfile
    resumeDevice = "/dev/disk/by-uuid/092d63f8-b441-4035-8049-7a46cbd6bea0";
    # sudo btrfs inspect-internal map-swapfile -r /.swap/swapfile
    kernelParams = ["resume_offset=533760"];

    kernelModules = ["kvm-amd"];
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
