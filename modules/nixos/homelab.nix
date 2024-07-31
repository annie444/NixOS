{ config, inputs, lib, pkgs, ... }:

with lib;

let
  cfg = config.roles.homelab;
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
    };

    hardware.nvidia-container-toolkit.enable = cfg.nvidia;

    boot.kernel.sysctl = {
      "fs.inotify.max_user_instances" = 2147483647;
      "fs.inotify.max_user_watches" = 1048576;
      "fs.inotify.max_queued_events" = 1048576;
    };

    sops.secrets."k3s/token" = {
      restartUnits = [ "k3s.service" ];
    };

    services.k3s = {
      enable = true;
      role = "server";
      tokenFile = cfg.tokenFile;
      extraFlags = toString ([
	      "--write-kubeconfig-mode \"0644\""
	      "--cluster-init"
	      "--disable servicelb"
	      "--disable traefik"
	      "--disable local-storage"
        "--kube-controller-manager-arg bind-address=0.0.0.0" 
        "--kube-proxy-arg metrics-bind-address=0.0.0.0" 
        "--kube-scheduler-arg bind-address=0.0.0.0" 
        "--etcd-expose-metrics true" 
        "--kubelet-arg containerd=/run/k3s/containerd/containerd.sock"
      ] ++ (if cfg.hostname == "homelab01" then [] else [
	        "--server https://${cfg.ipaddr}:6443"
      ]));
      clusterInit = (cfg.hostname == "homelab01");
    };

    services.openiscsi = {
      enable = true;
      name = "iqn.2016-04.com.open-iscsi:${cfg.hostname}";
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      k3s
      cifs-utils
      nfs-utils
      kubeshark
      docker
      runc 
    ]; 
  };
}
