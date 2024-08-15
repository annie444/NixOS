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

    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc

    ./hardware-configuration.nix
  ];

  networking.hostName = "homelab01";
  networking.hostId = "d58b8d19";

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
    "ddns/api_key" = {};
    "k3s/token" = {};
    "tailscale/auto_key" = {
      mode = "0770";
    };
  };

  templates = {
    services = {
      nvidiaDocker.enable = true;
      docker.enable = true;
      tailscale = {
        enable = true;
        autoconnect = {
          enable = true;
          keyFile = config.sops.secrets."tailscale/auto_key".path;
        };
      };
    };
    hardware.nvidia.enable = true;
  };

  roles.k3sBootstrap = {
    enable = true;
    nvidia = true;
    user = "annie";
    storageNode = true;
    gitSshHost = "git@github.com";
    gitRepo = "annie444/k3s-cluster";
    ip = "192.168.1.40";
    head = {
      self = true;
      ipAddress = "192.168.1.40";
    };
    k3sToken = config.sops.secrets."k3s/token".path;
    fluxGitAuth = config.sops.secrets.flux-git-auth.path;
    fluxSopsAge = config.sops.secrets.flux-age-key.path;
    minioCredentials = config.sops.secrets.minio-creds.path;
  };

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
