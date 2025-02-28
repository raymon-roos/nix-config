{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults" "umask=0077"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                passwordFile = "/tmp/secret.key";
                settings = {
                  allowDiscards = true;
                  # https://wiki.archlinux.org/title/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance
                  bypassWorkqueues = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "/rootfs" = {
                      mountpoint = "/";
                      mountOptions = ["defaults" "ssd" "noatime" "compress-force=zstd:4"];
                      # "compress-force=zstd", because supposedly zstd itself can better decide whether to compress than btrfs can
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["defaults" "ssd" "noatime" "compress-force=zstd:4"];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["defaults" "ssd" "noatime" "compress-force=zstd:4"];
                    };
                    "/var" = {
                      mountpoint = "/var";
                      mountOptions = ["defaults" "ssd" "noatime" "compress-force=zstd:4"];
                    };
                    "/snapshots" = {
                      mountpoint = "/snapshots";
                      mountOptions = ["defaults" "ssd" "noatime" "compress-force=zstd:4"];
                    };
                    "/swap" = {
                      mountpoint = "/.swap";
                      swap.swapfile.size = "9G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
