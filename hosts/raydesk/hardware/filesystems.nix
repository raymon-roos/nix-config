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

    "/home/ray/files/games" = {
      device = "/dev/disk/by-uuid/ac5e918a-bf06-451e-a830-48b644a9dd24";
      fsType = "ext4";
      options = ["defaults" "rw" "noatime" "commit=30" "nofail"];
    };

    "/home/ray/files/1-disk" = {
      device = "/dev/disk/by-uuid/75de5f29-56b1-438c-9fba-aa231a3f4b9e";
      fsType = "btrfs";
      options = ["defaults" "rw" "noatime" "compress-force=zstd:5" "nofail"];
    };

    "/home/ray/files/2-disk" = {
      device = "/dev/disk/by-uuid/2e3dd481-982f-40dc-a811-28ed6e07ecbb";
      fsType = "btrfs";
      options = ["defaults" "rw" "noatime" "compress-force=zstd:5" "nofail"];
    };

    "/home/ray/files/3-disk" = {
      device = "/dev/disk/by-uuid/9d78a044-9154-4f33-819c-7a5439a599a7";
      fsType = "btrfs";
      options = ["defaults" "rw" "noatime" "compress-force=zstd:5" "nofail"];
    };

    "/home/ray/files/4-disk" = {
      device = "/dev/disk/by-uuid/9e0d0c05-0165-4e02-92ff-7445d2c14072";
      fsType = "btrfs";
      options = ["defaults" "rw" "noatime" "compress-force=zstd:5" "nofail"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/944c7f07-498c-4112-95ff-f8760c5ddbb9";}
  ];
}
