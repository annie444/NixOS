{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.templates.services.nvidiaDocker;
in {
  options.templates.services.nvidiaDocker = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nvida-docker services.";
    };
  };
  config = lib.mkIf cfg.enable {
    templates.hardware.nvidia.enable = true;

    environment.systemPackages = with pkgs; [
      docker
      glibc
      pkg-config
      libelf
      libcap
      libseccomp
      libtirpc
      rpcsvc-proto
      go
      cudaPackages.fabricmanager
    ];

    hardware.nvidia-container-toolkit.enable = true;
  };
}
