{config, ...}:{
  boot = {
    crashDump.enable = true;
    enableContainers = true;

    supportedFilesystems = ["zfs"];

    extraModulePackages = with config.boot.kernelPackages; [opensnitch-ebpf];
    kernelParams = [
      "quiet"
      "splash"
    ];

    loader.grub = {
      enable = true;
      device = "nodev";
      backgroundColor = "#282A36";
      efiSupport = true;
      memtest86.enable = true;
      copyKernels = true;
    };

    tmp = {
      cleanOnBoot = true;

      # NOTE Large Nix builds can fail if the mounted tmpfs is not large enough.
      # Yes everything below 64GB of RAM is not enugth here for larger systems!
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };
}
