{ config, inputs, lib, pkgs, ... }:

with lib;

let
  cfg = config.roles.homelab;
  nvidiaContainerdSupport = pkgs.writeTextFile {
    name = "nvidia-containerd-config-template";
    destination = "/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl";
    text = ''
      {{ template "base" . }}

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
        privileged_without_host_devices = false
        runtime_engine = ""
        runtime_root = ""
        runtime_type = "io.containerd.runc.v2"
    '';
  };
in {

  options.roles.homelab = {
    enable = mkEnableOption "Enable homelab services";
    hostname = mkOption {
      type = types.str;
      default = "homelab01";
      description = "Hostname of the server";
    };
    tokenFile = mkOption {
      type = types.path;
      default = "/etc/k3s/token";
      description = "Path to the token file";
    };
    ipaddr = mkOption {
      type = types.str;
      description = "Hostname of the server";
    };
    nvidia = mkOption {
      type = types.bool;
      default = false;
      description = "Whether nvidia GPU support should be setup";
    };
  };
  config = mkIf cfg.enable {
    # Fixes for longhorn
    systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];

    virtualisation.docker = {
      enable = true;
      logDriver = "json-file";
    } // optionalAttrs cfg.nvidia { 
      enableNvidia = true; 
    };

    sops.secrets."k3s/token" = {
      restartUnits = [ "k3s.service" ];
    };

    services.k3s = {
      enable = false;
      role = "server";
      tokenFile = cfg.tokenFile;
      extraFlags = toString ([
	      "--write-kubeconfig-mode \"0644\""
	      "--cluster-init"
	      "--disable servicelb"
	      "--disable traefik"
	      "--disable local-storage"
      ] ++ (if cfg.hostname == "homelab01" then [] else [
	        "--server https://${cfg.ipaddr}:6443"
      ]));
      clusterInit = (cfg.hostname == "homelab01");
    };

    services.openiscsi = {
      enable = true;
      name = "iqn.2016-04.com.open-iscsi:${cfg.hostname}";
    };

    systemd.services.k3s.after = [ "sops-nix.service" ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      k3s
      cifs-utils
      nfs-utils
      kubeshark
      docker
      runc 
    ] ++ (if cfg.nvidia then [ 
      nvidiaContainerdSupport 
    ] else []); 
  };
}
