{
  config,
  lib,
  pkgs,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  no-offload = pkgs.writeShellScriptBin "no-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=0
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=
    export __GLX_VENDOR_LIBRARY_NAME=
    export __VK_LAYER_NV_optimus=
    exec "$@"
  '';
  cfg = config.templates.hardware.nvidia;
in {
  options.templates.hardware.nvidia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nvida drivers.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement = {
          enable = true;
          finegrained = false;
        };
      };
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
      ];

    services.xserver.videoDrivers = ["nvidia"];
    boot.initrd.kernelModules = ["nvidia"];
    boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];

    boot.kernelParams = ["module_blacklist=amdgpu"];

    boot.blacklistedKernelModules = ["nouveau"];

    nixpkgs.config.cudaSupport = true;

    environment = {
      systemPackages = with pkgs; [
        cudatoolkit
        libGLU
        libGL
        ncurses5
        linuxPackages.nvidia_x11
        glibc
        pkg-config
        libelf
        libcap
        libseccomp
        libtirpc
        rpcsvc-proto
        nvidia-offload
        no-offload
        go
        cudaPackages.fabricmanager
      ];

      sessionVariables = {
        LD_LIBRARY_PATH = ["${config.hardware.nvidia.package}/lib"];
        CUDA_PATH = "${pkgs.cudatoolkit}";
      };
    };
  };
}
