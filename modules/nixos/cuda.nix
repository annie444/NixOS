{ config, pkgs, lib, ... }:

let
  cfg = config.roles.cuda;
  unpatched-nvidia-driver = (config.hardware.nvidia.package.overrideAttrs (oldAttrs: {
    builder = ../../overlays/nvidia-builder.sh;
  }));

  nvidia-pkgs = with pkgs; [
    (lib.getBin glibc) # for ldconfig in preStart
    (lib.getBin unpatched-nvidia-driver)
    nvidia-k3s
    
  ];

  runtime-config = pkgs.runCommandNoCC "config.toml" {
    src = ../../overlays/config.toml;
  } ''
    cp $src $out
    substituteInPlace $out \
      --subst-var-by glibcbin ${lib.getBin pkgs.glibc}
    # substituteInPlace $out \
    #   --subst-var-by nvidia-drivers ${lib.getBin unpatched-nvidia-driver}
    substituteInPlace $out \
      --subst-var-by container-cli-path "PATH=${lib.makeBinPath nvidia-pkgs}"
  '';
in
{

  options.roles.cuda.enable = lib.mkEnableOption "Enable NVIDIA CUDA support";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = (with pkgs; [
      autoAddDriverRunpath
      cudatoolkit
      linuxPackages.nvidia_x11
      pciutils
      file
    ]) ++ (with pkgs.cudaPackages; [
      setupCudaHook
      nvidia_fs
      libnvjpeg
      libnpp
      libcusolver
      libcurand
      libcufile
      libcufft
      libcublas
      fabricmanager
      cutensor
      cudnn
      cuda_opencl
      cuda_nvprune
      cuda_nvprof
      cuda_nvml_dev
      cuda_gdb
    ]); 
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaPersistenced = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
    };
    
  };
}
