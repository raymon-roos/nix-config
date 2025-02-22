{...}: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=nixos" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=nix" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/var" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=var" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/root" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=home_root" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/opt" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=opt" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/home/ray" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=home_ray" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/srv" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=srv" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/usr/local" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=usr/local" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/snapshots" = {
      device = "/dev/disk/by-uuid/9f955791-5d56-460d-80d5-5dbd76620fc4";
      fsType = "btrfs";
      options = ["subvol=snapshots" "defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7375-7BEB";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    "/mnt/artix" = {
      device = "/dev/disk/by-uuid/82d648d8-abe0-4abf-9795-134a911e9530";
      fsType = "btrfs";
      options = ["defaults" "rw" "noatime" "compress-force=zstd:5" "ssd"];
    };

    "/home/ray/files/2-disk" = {
      device = "/dev/disk/by-uuid/2e3dd481-982f-40dc-a811-28ed6e07ecbb";
      fsType = "btrfs";
      options = ["defaults" "rw" "noatime" "compress-force=zstd:5"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/944c7f07-498c-4112-95ff-f8760c5ddbb9";}
  ];
}
