{pkgs, ...}: {
  services = {
    udev.packages = [pkgs.qmk-udev-rules];

    dbus.implementation = "broker";

    xserver = {
      videoDrivers = ["nvidia"];
    };

    openssh = {
      enable = false;
      hostKeys = [
        {
          comment = "raydesk system";
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
