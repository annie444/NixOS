{
  disko.devices = {
    disk = {
      nvme3 = {
        type = "disk";
        device = "/dev/nvme3n1";
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
                mountpoint = "/boot/efi";
              };
            };
            swap = {
	            size = "68G";
              content = {
                type = "swap";
		            resumeDevice = true;
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      nvme2 = {
        type = "disk";
        device = "/dev/nvme2n1";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            }; 
          };
        };
      };
      nvme1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            }; 
          };
        };
      };
      nvme0 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            }; 
          };
        };
      }; 
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
        datasets = {
          zfs_root = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          zfs_home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}
