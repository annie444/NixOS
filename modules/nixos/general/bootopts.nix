{config, ...}: {
  boot = {
    crashDump.enable = true;
    enableContainers = true;

    extraModulePackages = with config.boot.kernelPackages; [opensnitch-ebpf];
    kernelParams = [
      "quiet"
      "splash"
    ];

    tmp = {
      cleanOnBoot = true;

      # NOTE Large Nix builds can fail if the mounted tmpfs is not large enough.
      # Yes everything below 64GB of RAM is not enugth here for larger systems!
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };
}
