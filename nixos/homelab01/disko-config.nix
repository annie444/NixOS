{
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S6B0NL0TC04770P";
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
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S6B0NL0TC34395K";
        content = {
          type = "gpt";
          partitions = {
	          primary = {
              size = "100%";
	            content = {
	              type = "filesystem";
		            format = "ext4";
		            mountpoint = "/mnt/nvme1";
	            };
            }; 
          };
        };
      };
      hitachi = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Hitachi_HUA722020ALA330_JK11B1B9K2KBRF";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
	            content = {
	              type = "filesystem";
		            format = "ext4";
		            mountpoint = "/mnt/hitachi";
	            };
            };
          };
        };
      }; 
      segate = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000LM007-1R8174_WDZ13WRE";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
	            content = {
	              type = "filesystem";
		            format = "ext4";
		            mountpoint = "/mnt/segate";
	            };
            };
          }; 
        };
      }; 
      wd1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD40EFAX-68JH4N1_WD-WX62D22EKCAT";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
	            content = {
	              type = "filesystem";
		            format = "ext4";
		            mountpoint = "/mnt/wd1";
	            };
            };
          };
        };
      }; 
      wd2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD40EFAX-68JH4N1_WD-WX62D22LYL41";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
	            content = {
	              type = "filesystem";
		            format = "ext4";
		            mountpoint = "/mnt/wd2";
	            };
            };
          };
        };
      }; 
    };
  };
}
