# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    outputs.nixosModules.templates
    inputs.nixos-hardware.nixosModules.raspberry-pi-5

    ./hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = "arm64-linux";

  networking.hostName = "homelab03";

  sops.secrets = {
    "tailscale/auto_key" = {
      restartUnits = ["tailscaled.service"];
      mode = "0770";
    };
  };

  templates.services = {
    tailscale = {
      enable = true;
      autoconnect = {
        enable = true;
        keyFile = config.sops.secrets."tailscale/auto_key".path;
      };
    };
  };
}
