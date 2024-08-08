# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{lib, config, ...}: {
  boot = {
    crashDump.enable = true;
    enableContainers = true;
    supportedFilesystems = ["zfs"];
    extraModulePackages = with config.boot.kernelPackages; [ opensnitch-ebpf ];
    kernelParams = [
      "quiet"
      "splash"
    ];

    loader.grub= {
      enable = true;
      device = "nodev";
      backgroundColor = "#282A36";
      efiSupport = true;
      memtest86.enable = true;
      copyKernels = true;
    };
    tmp.cleanOnBoot = true;
  };

  networking.useDHCP = lib.mkDefault true;

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}
