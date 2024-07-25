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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid5";
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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid5";
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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid5";
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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid5";
              };
            }; 
          };
        };
      }; 
    };
    mdadm = {
      raid5 = {
        type = "mdadm";
        level = 5;
        metadata = "1.2";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
