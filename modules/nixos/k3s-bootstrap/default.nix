{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.roles.k3sBootstrap;
in {
  options.roles.k3sBootstrap = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Bootstrap a k3s cluster with flux and cilium
      '';
    };
    storageNode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether this node should have sotrage utilities installed
      '';
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
    gitSshHost = lib.mkOption {
      type = lib.types.str;
      default = "git@github.com";
      description = "The ssh host to connect to flux";
    };
    gitRepo = lib.mkOption {
      type = lib.types.str;
      description = "The repo to bootstrap flux with";
    };
    ip = lib.mkOption {
      type = lib.types.str;
    };
    head = {
      self = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Is this the head node?";
      };
      ipAddress = lib.mkOption {
        type = lib.types.str;
        description = "IP address of the head node";
      };
    };
    k3sToken = lib.mkOption {
      type = lib.types.path;
      description = "K3s bootstrap token";
    };
    fluxGitAuth = lib.mkOption {
      type = lib.types.path;
      description = ''
        # 1. flux create secret git flux-git-auth --url="ssh://<git-ssh-domain>/<git-repo>.git" --private-key-file={{ .private_ssh_keyfile }} --export > flux-git-secret.yaml
        # 2. manually change the known_hosts to `ssh-keyscan -p 22 <git-ssh-domain>` ssh-ed25519 output
        # 3. encrypt yaml with age
      '';
    };
    fluxSopsAge = lib.mkOption {
      type = lib.types.path;
      description = "Path to the flux sops age secret";
    };
    minioCredentials = lib.mkOption {
      type = lib.types.path;
      description = ''
        File containing the MINIO_ROOT_USER, default is "minioadmin", and
        MINIO_ROOT_PASSWORD (length >= 8), default is "minioadmin"; in the format of
        an EnvironmentFile=, as described by systemd.exec(5). The acess permission must
        be set to 770 for minio:minio.'';
    };
  };

  config = lib.mkIf cfg.enable {
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
      hardware = lib.mkIf cfg.nvidia {
        nvidia = {
          enable = true;
        };
      };
      services = {
        k3s = {
          enable = true;
          tokenFile = cfg.k3sToken;
          head = {
            self = cfg.head.self;
            ipAddress = cfg.head.ipAddress;
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
            metrics-server = false;
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
              credentialsFile = cfg.minioCredentials;
              buckets = ["volsync" "postgres" "logs"];
              dataDir = ["/mnt/minio"];
              ipAddress = cfg.head.ipAddress;
            };
          };
        };
      };
    };

    powerManagement.cpuFreqGovernor = "ondemand";

    environment = {
      systemPackages = with pkgs;
        [
          gnutar
          ser2net
          par2cmdline
          rsync
          gzip
        ]
        ++ (
          if cfg.storageNode
          then [
            ceph
            ceph-csi
            libceph
            (writeShellScriptBin "zap-osd" ''
              #!/usr/bin/env bash

              zap_osd() {
                sgdisk -Z $1
                continue_prompt
              }

              confirm() {
                read -r -p "Zap OSD device $1?, confirm with yes (y/N): " choice
                case "$choice" in
                  y|Y|yes|Yes)
                    echo "zapping device..."
                    zap_osd $1
                    ;;
                  *)
                    exit 0
                    ;;
                esac
              }

              continue_prompt() {
                read -r -p "Would you like to continue? (y/N): " choice
                case "$choice" in
                  y|Y|yes|Yes)
                    select_device
                    ;;
                  *)
                    exit 0
                    ;;
                esac
              }

              select_device() {
                echo "Device tree:"
                lsblk -T -n --output=NAME
                echo ""
                read -r -p 'Which osd would you like to remove?: ' device
                stat "$device" 2>&1 /dev/null
                status=$?
                case "$status" in
                  0)
                    confirm $device
                    ;;
                  *)
                    echo "Device $device does not exist"
                    exit 1
                    ;;
                esac
              }

              if [ "$EUID" -ne 0 ] ; then
                echo "Please run as root"
                exit 1
              fi

              select_device
            '')
          ]
          else []
        );
    };

    users = {
      groups = {
        data = {
          name = "data";
          members = ["${cfg.user}"];
          gid = 1000;
        };
      };
    };

    systemd.tmpfiles.rules =
      [
        "d /opt/k3s 0775 ${cfg.user} data -"
        "d /opt/k3s/data 0775 ${cfg.user} data -"
        "d /home/${cfg.user}/.config 0775 ${cfg.user} data -"
        "d /home/${cfg.user}/.config/sops 0775 ${cfg.user} data -"
        "d /home/${cfg.user}/.config/sops/age 0775 ${cfg.user} data -"
        "d /home/${cfg.user}/.kube 0775 ${cfg.user} data -"
        "d /var/lib/rancher/k3s/server/manifests 0775 root data -"
        "L /home/${cfg.user}/.kube/config  - - - - /etc/rancher/k3s/k3s.yaml"
      ]
      ++ lib.optionals cfg.head.self [
        "L /var/lib/rancher/k3s/server/manifests/flux.yaml - - - - /etc/k3s/flux.yaml"
        "L /var/lib/rancher/k3s/server/manifests/flux-git-auth.yaml - - - - ${cfg.fluxGitAuth}"
        "L /var/lib/rancher/k3s/server/manifests/flux-sops-age.yaml - - - - ${cfg.fluxSopsAge}"
        "L /var/lib/rancher/k3s/server/manifests/00-coredns-custom.yaml - - - - /etc/k3s/coredns-custom.yaml"
      ];

    # required for deploy-rs
    nix.settings.trusted-users = ["root" "${cfg.user}"];

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
          url: ssh://${cfg.gitSshHost}/${cfg.gitRepo}
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

    environment.etc."k3s/coredns-custom.yaml" = {
      mode = "0750";
      text = ''
        apiVersion: v1
        kind: ConfigMap
        metadata:
          name: coredns-custom
          namespace: kube-system
        data:
          domain.server: |
            ${config.networking.hostName}.home:53 {
              errors
              health
              ready
              hosts {
                ${cfg.ip} ${config.networking.hostName}.home
                fallthrough
              }
              prometheus :9153
              forward . /etc/resolv.conf
              cache 30
              loop
              reload
              loadbalance
            }
      '';
    };

    environment.etc."ser2net.yaml" = {
      mode = "0755";
      text = ''
        connection: &con01
          accepter: tcp,20108
          connector: serialdev,/dev/ttyACM0,115200n81,nobreak,local
          options:
            kickolduser: true
      '';
    };

    systemd.services.ser2net = {
      wantedBy = ["multi-user.target"];
      description = "Serial to network proxy";
      after = ["network.target" "dev-ttyACM0.device"];
      serviceConfig = {
        Type = "simple";
        User = "root"; # todo user with only dialout group?
        ExecStart = ''${pkgs.ser2net}/bin/ser2net -n -c /etc/ser2net.yaml'';
        ExecReload = ''kill -HUP $MAINPID'';
        Restart = "on-failure";
      };
    };
  };
}
