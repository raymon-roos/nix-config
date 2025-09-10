{...}: {
  services = {
    auto-cpufreq = {
      enable = false;
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

    watt = {
      enable = true;
      settings = {
        battery_charge_thresholds = [40 80];
        charger = {
          governor = "performance";
          turbo = "auto";
          enable_auto_turbo = true;
          turbo_auto_settings = {
            load_threshold_high = 60.0;
            load_threshold_low = 30.0;
            temp_threshold_high = 60.0;
            initial_turbo_state = false;
          };
          epp = "performance";
          epb = "balance_performance";
        };

        battery = {
          governor = "powersave";
          turbo = "auto";
          enable_auto_turbo = true;
          turbo_auto_settings = {
            load_threshold_high = 70.0;
            load_threshold_low = 40.0;
            temp_threshold_high = 55.0;
            initial_turbo_state = false;
          };
          epp = "performance";
          epb = "balance_performance";
        };

        daemon = {
          poll_interval_sec = 7;
          adaptive_interval = true;
          min_poll_interval_sec = 3;
          max_poll_interval_sec = 40;
          throttle_on_battery = true;
          log_level = "Info";
          stats_file_path = "/var/run/watt-stats";
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
