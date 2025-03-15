{pkgs, ...}: {
  services = {
    udev.packages = [pkgs.qmk-udev-rules];

    dbus.implementation = "broker";

    xserver = {
      videoDrivers = ["nvidia"];
      autoRepeatDelay = 130;
      autoRepeatInterval = 15;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    openssh = {
      enable = false;
      startWhenNeeded = true;
      hostKeys = [
        {
          comment = "raydesk system";
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      settings = {
        PermitRootLogin = "no";
        X11Forwarding = false;
        PasswordAuthentication = false;
      };
    };

    smartd.enable = true;
  };
}
