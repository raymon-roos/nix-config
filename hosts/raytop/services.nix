{...}: {
  services = {
    dbus.implementation = "broker";

    thermald.enable = true;

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    xserver = {
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
          comment = "raytop system";
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
