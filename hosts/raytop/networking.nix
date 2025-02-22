{lib, ...}: {
  networking = {
    hostName = "raytop";
    # wireless.enable = true;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };
}
