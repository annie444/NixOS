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
    outputs.nixosModules.k3sBootstrap
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-pc

    ./hardware-configuration.nix
  ];

  networking.hostName = "homelab02";

  sops.secrets = {
    "tailscale/auto_key" = {
      restartUnits = ["tailscaled.service"];
      mode = "0770";
    };
  };

  templates = {
    services = {
      docker.enable = true;
      tailscale = {
        enable = true;
        autoconnect = {
          enable = true;
          keyFile = config.sops.secrets."tailscale/auto_key".path;
        };
      };
    };
    system.grub.enable = true;
  };

  services.vault = {
    enable = true;
    address = "192.168.1.42:8200";
    storageBackend = "raft";
    storagePath = "/var/lib/vault";
    storageConfig = ''
      node_id = "vault-node-1"
    '';
  };
}
