{ config, lib, pkgs, nixpkgs-unstable, inputs, ... }:
let
  cfg = config.roles.k3s-bootstrap;
in
{
  imports = with inputs.self.nixosModules; [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.roles.k3s-bootstrap = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Bootstrap a k3s cluster with flux and cilium";
    };
    nvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nvidia support";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "The user that will have admin permissions to the cluster";
    };
    git-ssh-host = lib.mkOption {
      type = lib.types.str;
      default = "git@github.com";
      description = "The ssh host to connect to flux";
    };
    git-repo = lib.mkOption {
      type = lib.types.str;
      description = "The repo to bootstrap flux with";
    };
    head = {
      self = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Is this the head node?";
      };
      ip-address = lib.mkOption {
        type = lib.types.str;
        description = "IP address of the head node";
      };
    };
    k3s-token = lib.mkOption {
      type = lib.types.path;
      description = "K3s bootstrap token";
    };
    flux-git-auth = lib.mkOption {
      type = lib.types.path;
      description = ''
        # 1. flux create secret git flux-git-auth --url="ssh://<git-ssh-domain>/<repo>.git" --private-key-file={{ .private_ssh_keyfile }} --export > flux-git-secret.yaml
        # 2. manually change the known_hosts to `ssh-keyscan -p 22 <git-ssh-domain>` ssh-ed25519 output
        # 3. encrypt yaml with age
      '';
    };
    flux-sops-age = lib.mkOption {
      type = lib.types.path;
      description = "Path to the flux sops age secret";
    };
    minio-credentials = lib.mkOption {
      type = lib.types.path;
      description = ''
        File containing the MINIO_ROOT_USER, default is "minioadmin", and
        MINIO_ROOT_PASSWORD (length >= 8), default is "minioadmin"; in the format of
        an EnvironmentFile=, as described by systemd.exec(5). The acess permission must
        be set to 770 for minio:minio.'';
    };
  };

  networking.firewall = {
    # NOTE: `loose` required for cilium when using without kube-proxy replacement to get working livenes probe for pods. With this settings the cluster is mostly usable with exception of
    # Cilium DNS Filtering: msg="Timeout waiting for response to forwarded proxied DNS lookup" dnsName=vpn-gateway-pod-gateway.vpn-gateway.svc.cluster.local. error="read udp 10.42.0.183:43844->10.42.0.176:53: i/o timeout" ipAddr="10.42.0.183:43844" subsys=fqdn/dnsproxy 
    # => Therefore we have to use `checkReversePath=false` to get our vpn-gateway CiliumNetworkPolicy with DNS Filter working (when installing without cilium kube-proxy replacement).
    checkReversePath = false;     
    allowedTCPPorts = [
      3000 # nixos gitea
      8080 # unifi control
      18089 # monerod rpc
      20108 # zigbee adapter via serial2net
      22000 # syncthing local discovery
    ];
    allowedUDPPorts = [
      3478 # unifi stun
      10001 # unifi discovery
      21027 # syncthing discovery broadcast
      51820 # wg-easy
    ];
  };

  services.k3s.package = pkgs.k3s; 
  systemd.services.k3s.serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 60";

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  templates = {
    apps = {
      modernUnix.enable = true;
      monitoring.enable = true;
    };
    system = {
      hardware = lib.mkIf cfg.nvidia {
        nvidia = {
          enable = true;
        };
      };
    };
    services = {
      k3s = {
        enable = true;
        tokenFile = cfg.k3s-token;
        head = {
          self = cfg.head.self;
          ip = cfg.head.ip-address;
        };
        prepare = {
          cilium = true;
        };
        services = {
          kube-proxy = true;
          flux = cfg.head.self;
          servicelb = false;
          traefik = false;
          local-storage = false;
          metrics-server = true;
          coredns = false;
          flannel = false;
        };
        bootstrap = lib.mkIf cfg.head.self {
          helm = {
            enable = true;
            completedIf = "get CustomResourceDefinition -A | grep -q 'cilium.io'";
            helmfile = "/etc/k3s/helmfile.yaml";
          };
        };
        addons = lib.mkIf cfg.head.self {
          minio = {
            enable = true;
            credentialsFile = config.age.secrets.minio-credentials.path;
            buckets = ["volsync" "postgres" "logs"];
            dataDir = ["/mnt/backup/minio"];
          };
        };
      };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  environment = {
    systemPackages = with pkgs; [
      gnutar
      ser2net
      par2cmdline
      rsync
      gzip
    ];
  };

  users = {
    groups = {
      data = { 
        name = "data"; 
        members = ["${user}"]; 
        gid = 1000;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /opt/k3s 0775 ${user} data -"
    "d /opt/k3s/data 0775 ${user} data -"
    "d /home/${user}/.config 0775 ${user} data -"
    "d /home/${user}/.config/sops 0775 ${user} data -"
    "d /home/${user}/.config/sops/age 0775 ${user} data -"
    "d /home/${user}/.kube 0775 ${user} data -"
    "d /var/lib/rancher/k3s/server/manifests 0775 root data -"
    "L /home/${user}/.kube/config  - - - - /etc/rancher/k3s/k3s.yaml"
  ] ++ lib.optional cfg.head.self [
    "L /var/lib/rancher/k3s/server/manifests/flux.yaml - - - - /etc/k3s/flux.yaml"
    "L /var/lib/rancher/k3s/server/manifests/flux-git-auth.yaml - - - - ${cfg.flux-git-auth}"
    "L /var/lib/rancher/k3s/server/manifests/flux-sops-age.yaml - - - - ${cfg.flux-sops-age}"                                  
    "L /var/lib/rancher/k3s/server/manifests/00-coredns-custom.yaml - - - - /etc/k3s/coredns-custom.yaml" # use 00- prefix to deploy this first                                 
  ];
  
  # required for deploy-rs
  nix.settings.trusted-users = [ "root" "${user}" ];

  # NOTE: we use the ssh key not the git key
  # git url schmeas: 
  # - '<git-ssh-host>:r/gitops-homelab.git'
  # - 'ssh://<git-ssh-host>/home/git/r/gitops-homelab.git'
  # - 'ssh://<git-ssh-host>/~/r/gitops-homelab.git' => ~ is not supported in flux git repo url!
  # flux git secret:
  # 1. flux create secret git flux-git-auth --url="ssh://git@${domain}/~/r/gitops-homelab.git" --private-key-file={{ .private_ssh_keyfile }} --export > flux-git-secret.yaml
  # 2. manually change the knwon_hosts to `ssh-keyscan -p 22 ${domain}` ssh-ed25519 output
  # 3. encrypt yaml with age
  environment.etc."k3s/flux.yaml" = lib.mkIf cfg.head.self {
    mode = "0750";
    text = ''
      apiVersion: source.toolkit.fluxcd.io/v1
      kind: GitRepository
      metadata:
        name: flux-system
        namespace: flux-system
      spec:
        interval: 2m
        ref:
          branch: main
        secretRef:
          name: flux-git-auth
        url: ssh://${cfg.git-ssh-host}:${cfg.repo}
      ---
      apiVersion: kustomize.toolkit.fluxcd.io/v1
      kind: Kustomization
      metadata:
        name: flux-system
        namespace: flux-system
      spec:
        interval: 2m
        path: ./kubernetes/flux
        prune: true
        wait: false
        sourceRef:
          kind: GitRepository
          name: flux-system
        decryption:
          provider: sops
          secretRef:
            name: sops-age
    '';
  };

  environment.etc."k3s/helmfile.yaml" = lib.mkIf cfg.head.self {
    mode = "0750";
    text = ''
      repositories:
        - name: coredns
          url: https://coredns.github.io/helm
        - name: cilium
          url: https://helm.cilium.io
      releases:
        - name: cilium
          namespace: kube-system
          chart: cilium/cilium
          version: 1.16.0
          values: ["${./cilium.values.yaml}"]
          wait: true
        - name: coredns
          namespace: kube-system
          chart: coredns/coredns
          version: 1.32.0
          values: ["${./coredns.values.yaml}"]
          wait: true
    '';
  };
}
