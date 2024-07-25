{ config, lib, pkgs, meta, ... }:

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
  };
  config = mkIf cfg.enable {
    # Fixes for longhorn
    systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];
    virtualisation.docker.logDriver = "json-file";

    services.k3s = {
      enable = true;
      role = "server";
      token = "mysecrettoken";
      extraFlags = toString ([
	      "--write-kubeconfig-mode \"0644\""
	      "--cluster-init"
	      "--disable servicelb"
	      "--disable traefik"
	      "--disable local-storage"
      ] ++ (if cfg.hostname == "homelab01" then [] else [
	        "--server https://homelab01:6443"
      ]));
      clusterInit = (cfg.hostname == "homelab01");
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
       k3s
       cifs-utils
       nfs-utils
    ];
  };

}
