{...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 15;
      efi.canTouchEfiVariables = true;
    };

    tmp.useTmpfs = true;

    initrd = {
      availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod"];
      kernelModules = [];
    };

    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };
}
