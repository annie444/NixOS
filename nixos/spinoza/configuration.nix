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
    outputs.nixosModules.gui
    outputs.nixosModules.cuda
    outputs.nixosModules.nvidia-graphics

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

  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  fonts.enableDefaultPackages = true;

  time.timeZone = "Americas/Los_Angeles";

  networking.hostName = "spinoza";
  networking.hostId = "4c0902ca";

  roles.nvidia-graphics.enable = true;
  roles.cuda.enable = true;
  roles.gui.enable = true;

  services = {
    printing.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
  sound.enable = true;
}
