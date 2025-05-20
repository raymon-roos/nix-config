{...}: {
  services = {
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

    openssh = {
      enable = false;
      hostKeys = [
        {
          comment = "raytop system";
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
