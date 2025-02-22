{lib, ...}: {
  networking = {
    useDHCP = lib.mkDefault true;

    hostName = "raydesk";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [49164 6881];
      allowedUDPPorts = [49164 6881];
    };
  };
}
