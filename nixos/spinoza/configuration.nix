{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.templates

    # Or modules from other flakes (such as nixos-hardware):
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./pkgs.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  fonts.enableDefaultPackages = true;
  
  networking.hostName = "spinoza";
  networking.hostId = "4c0902ca";

  templates = {
    apps = {
      modernUnix.enable = true;
      monitoring.enable = true;
    };
    hardware.nvidia.enable = true;
    services = {
      docker.enable = true;
      nvidiaDocker.enable = true;
      podman = {
        enable = true;
        user = "annie";
      };
      printer.enable = true;
      smartdWebui.enable = true;
    };
    system = {
      grub.enable = true;
      desktop = {
        enable = true;
        waydroid.enable = true;
        sddm.enable = true;
        portals = with pkgs; [
          xdg-desktop-portal-wlr
          kdePackages.xdg-desktop-portal-kde
        ];
        users = ["annie"];
      };
    };
  };
}
