# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
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
  networking.hostId = "10fe182f";

  sops.secrets = {
    flux-age-key = {
      sopsFile = ../../secrets/k3s/flux-age-key.yaml.enc;
      format = "binary";
    };
    flux-git-auth = {
      sopsFile = ../../secrets/k3s/flux-git-auth.yaml.enc;
      format = "binary";
    };
    minio-creds = {
      sopsFile = ../../secrets/k3s/minio-creds.env.enc;
      format = "binary";
      mode = "0770";
      owner = "minio";
      group = "minio";
    };
    "k3s/token" = {};
    "tailscale/auto_key" = {
      mode = "0770";
    };
  };

  templates.services = {
    docker.enable = true;
    tailscale = {
      enable = true;
      autoconnect = {
        enable = true;
        keyFile = config.sops.secrets."tailscale/auto_key".path;
      };
    };
  };

  roles.k3sBootstrap = {
    enable = true;
    nvidia = false;
    user = "annie";
    gitSshHost = "git@github.com";
    gitRepo = "annie444/k3s-cluster";
    head = {
      self = false;
      ipAddress = "192.168.1.40";
    };
    k3sToken = config.sops.secrets."k3s/token".path;
    fluxGitAuth = config.sops.secrets.flux-git-auth.path;
    fluxSopsAge = config.sops.secrets.flux-age-key.path;
    minioCredentials = config.sops.secrets.minio-creds.path;
  };
}
