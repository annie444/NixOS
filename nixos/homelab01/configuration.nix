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
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.homelab
    outputs.nixosModules.k3s-cuda

    # Or modules from other flakes (such as nixos-hardware):
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.nvidia-overlay 
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  time.timeZone = "Americas/Los_Angeles";

  networking.hostName = "homelab01";
  networking.hostId = "d58b8d19";

  roles.k3s-cuda.enable = true;

  roles.homelab = {
    enable = true;
    hostname = "homelab01";
    tokenFile = config.sops.secrets."k3s/token".path;
    ipaddr = "192.168.1.40";
    nvidia = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  sops.secrets."ddns/api_key" = {};

  sops.templates."1948-password.conf" = {
    content = ''
      password = "${config.sops.placeholder."ddns/api_key"}"
    '';
    owner = "inadyn";
    group = "inadyn";
  };

  services.inadyn = {
    enable = true;
    user = "inadyn";
    group = "inadyn";
    logLevel = "notice";
    settings = {
      custom = {
        "onenineeightfour" = {
          ssl = true;
          ddns-server = "api.1984.is";
          ddns-path = "/1.0/freedns/?apikey=%p&domain=%h&ip=%i";
          include = config.sops.templates."1948-password.conf".path;
          hostname = "jpeg.gay";
        };
      };
      allow-ipv6 = false;
      forced-update = 86400;
    };
  };
}

