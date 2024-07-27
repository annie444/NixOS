{
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
	          boot = {
              size = "3G";
              type = "ef02"; # for grub MBR
	            content = {
	              type = "filesystem";
		            format = "vfat";
		            mountpoint = "/boot";
	            };
            };
            ESP = {
              size = "3G";
              type = "ef00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/EFI";
              };
            };
            swap = {
	            size = "168G";
              content = {
                type = "swap";
		            resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              }; 
	          };
          };
        };
      };
      nvme1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "zfs";
          pool = "zpool0";
        };
      };
      hitachi = {
        type = "disk";
        device = "/dev/sdc";
        content = {
          type = "zfs";
          pool = "zpool0";
        };
      }; 
      segate = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "zfs";
          pool = "zpool0";
        };
      }; 
      wd1 = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "zfs";
          pool = "zpool1";
        };
      }; 
      wd2 = {
        type = "disk";
        device = "/dev/sdd";
        content = {
          type = "zfs";
          pool = "zpool1";
        };
      }; 
    };
    zpool = {
      zpool0 = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zpool0@blank$' || zfs snapshot zpool0@blank";
        datasets = {
          zfs_fs0 = {
            type = "zfs_fs";
            mountpoint = "/mnt/zfs_fs0";
            options = {
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
      zpool1 = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zpool1@blank$' || zfs snapshot zpool1@blank";
        datasets = {
          zfs_fs1 = {
            type = "zfs_fs";
            mountpoint = "/mnt/zfs_fs1";
            options = {
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };
}
