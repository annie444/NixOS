{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.templates.services.k8s;
in {
  options.templates.services.k8s = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable K8S Cluster.";
    };

    tokenFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to token file
      '';
    };

    nvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled nvidia-container-runtime will be configured for use with k8s
      '';
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
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "Hostname of the head node";
      };
      apiPort = lib.mkOption {
        type = lib.types.int;
        default = 6443;
        description = "Port of the k8s api";
      };
    };

    bootstrap = {
      helm = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Helm bootsrap service for K8S Cluster.";
        };
        completedIf = lib.mkOption {
          type = lib.types.str;
          description = ''
            kubectl command condition meet when bootstrap is completed
          '';
        };
        helmfile = lib.mkOption {
          type = lib.types.str;
          description = ''
            Path to bootstrap helmfile
          '';
        };
      };
    };

    prepare = {
      cilium = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Set required preconditions to install cilium to k8s cluster
        '';
      };
    };

    services = {
      coredns = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          If enabled coredns will be installed to k8s cluster
        '';
      };

      kube-proxy = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          If enabled k8s kube-proxy will be enabled on k8s cluster
        '';
      };

      flannel = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          If enabled flannel will be enabled on k8s cluster
        '';
      };

      flux = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          If enabled flux will be installed to k8s cluster
        '';
      };

      servicelb = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If enabled klipper-lb will be enabled on k8s cluster
        '';
      };

      traefik = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If enabled traefik will be enabled on k8s cluster
        '';
      };

      local-storage = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If enabled local-storage will be enabled on k8s cluster
        '';
      };

      metrics-server = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If enabled metrics-server will be enabled on k8s cluster
        '';
      };
    };

    addons = {
      nfs = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            If enabled a localhost only nfs-server will be enabled on node
          '';
        };
        path = lib.mkOption {
          type = lib.types.str;
          default = "/mnt/nfs";
          description = ''
            Host path for nfs server share
          '';
        };
      };

      minio = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            If enabled minio will be enabled on node
          '';
        };
        ipAddress = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = ''
            IP address of the minio server
          '';
        };
        credentialsFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = ''
            File containing the MINIO_ROOT_USER, default is "minioadmin", and
            MINIO_ROOT_PASSWORD (length >= 8), default is "minioadmin"; in the format of
            an EnvironmentFile=, as described by systemd.exec(5). The acess permission must
            be set to 770 for minio:minio.
          '';
        };
        region = lib.mkOption {
          type = lib.types.str;
          default = "local";
          description = ''
            The physical location of the server.
          '';
        };
        buckets = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["volsync" "postgres"];
          description = ''
            Bucket name.
          '';
        };
        dataDir = lib.mkOption {
          default = ["/var/lib/minio/data"];
          type = lib.types.listOf (lib.types.either lib.types.path lib.types.str);
          description = "The list of data directories or nodes for storing the objects.";
        };
      };
    };
    lib = mkOption {
      description = "Common functions for the kubernetes modules.";
      default = {
        inherit mkCert;
        inherit mkKubeConfig;
        inherit mkKubeConfigOptions;
      };
      type = types.attrs;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kompose
      kubernetes
      age
      cilium-cli
      fluxcd
      kubernetes-helm
      helmfile
      git
      go-task
      minio-client
      jq
      krelay
      kubectl
      nfs-utils
      openiscsi
      openssl_3
      sops
    ];

    services = {
      kubernetes = let
        # These are the default paths used with Kubeadm
        dataDir = "/var/lib/kubernetes";
        secretsPath = dataDir + "/pki";

        # This is the host:port of the api server
        kubeConfigServer = "https://${cfg.head.hostname}:${toString cfg.head.apiPort}";

        # Certificates with their default attributes lister
        # CN: CommonName
        # OU: OrganizationalUnit
        # O: Organization
        # L: Locality
        # S: StateOrProvinceName
        # C: CountryName

        # Certificate Authorities
        # Used by etcd -- CN = etcd-ca
        # Used by            | Key Args            | Cert Args
        # -------------------|---------------------|---------------------
        # kube-apiserver     |                     | --etcd-cafile
        # -------------------|---------------------|---------------------
        # etcd               |                     | --trusted-ca-file
        #                    |                     | --peer-trusted-ca-file
        # -------------------|---------------------|---------------------
        # etcdctl            |                     | --cacert
        etcdCA = secretsPath + "/etcd/ca.crt";
        etcdCAKey = secretsPath + "/etcd/ca.key";

        # Used by the cluster -- CN = kubernetes-ca
        # Used by                 | Key Args                   | Cert Args
        # ------------------------|----------------------------|---------------------
        # kube-apiserver          |                            | --client-ca-file
        # ------------------------|----------------------------|---------------------
        # kube-controller-manager | --cluster-signing-key-file | --client-ca-file
        #                         |                            | --root-ca-file
        #                         |                            | --cluster-signing-cert-file
        clusterCA = secretsPath + "/ca.crt";
        clusterCAKey = secretsPath + "/ca.key";

        # Used by the front-end proxy -- CN = kubernetes-front-proxy-ca
        # Used by                 | Key Args      | Cert Args
        # ------------------------|---------------|---------------------
        # kube-apiserver          |               | --requestheader-client-ca-file
        # ------------------------|---------------|---------------------
        # kube-controller-manager |               | --requestheader-client-ca-file
        frontProxyCA = secretsPath + "/front-proxy-ca.crt";
        frontProxyCAKey = secretsPath + "/front-proxy-ca.key";

        # Certificates

        # (CA = etcd-ca); CN = kube-etcd; O = null; L = <any>; S = <any>; C = <any>;
        # kind = client, server
        # usage = digital signature, key encipherment, server auth, client auth
        # SAN = config.networking.hostName, 
        # config.networking.fqdnOrHostName,
        # config.networking.ipAddress, 
        # localhost, 127.0.0.1,
        # kube-etcd + config.kubernetes.etcd.clusterDomain
        # <all> + :<port>
        # Used by            | Key Args            | Cert Args
        # -------------------|---------------------|---------------------
        # etcd               | --key-file          | --cert-file
        kubeEtcdCert = secretsPath + "/etcd/server.crt";
        kubeEtcdKey = secretsPath + "/etcd/server.key";
       
        # (CA = etcd-ca); CN = kube-etcd-peer; O = null; L = <any>; S = <any>; C = <any>;
        # kind = client, server
        # usage = digital signature, key encipherment, server auth, client auth
        # SAN = config.networking.hostName, 
        # config.networking.fqdnOrHostName,
        # config.networking.ipAddress, 
        # localhost, 127.0.0.1,
        # kube-etcd-peer + config.kubernetes.etcd.clusterDomain
        # <all> + :<port>
        # Used by            | Key Args            | Cert Args
        # -------------------|---------------------|---------------------
        # etcd               | --peer-key-file     | --peer-cert-file
        kubeEtcdPeerCert = secretsPath + "/etcd/peer.crt";
        kubeEtcdPeerKey = secretsPath + "/etcd/peer.key";

        # (CA = etcd-ca); CN = kube-etcd-healthcheck-client; O = null; L = <any>; S = <any>; C = <any>;
        # kind = client
        # usage = digital signature, key encipherment, client auth
        # Used by            | Key Args            | Cert Args
        # -------------------|---------------------|---------------------
        # etcdctl            | --key               | --cert
        healthcheckCert = secretsPath + "/etcd/healthcheck-client.crt";
        healthcheckKey = secretsPath + "/etcd/healthcheck-client.key";

        # (CA = etcd-ca); CN = kube-apiserver-etcd-client; O = null; L = <any>; S = <any>; C = <any>;
        # kind = client
        # usage = digital signature, key encipherment, client auth
        # Used by            | Key Args            | Cert Args
        # -------------------|---------------------|---------------------
        # kube-apiserver     | --etcd-keyfile      | --etcd-certfile
        etcdApiCert = secretsPath + "/etcd/apiserver-etcd-client.crt";
        etcdApiKey = secretsPath + "/etcd/apiserver-etcd-client.key";
       
        # (CA = kubernetes-ca); CN = kube-apiserver; O = null; L = <any>; S = <any>; C = <any>;
        # kind = server
        # usage = digital signature, key encipherment, server auth
        # SAN = config.networking.hostName, 
        # config.networking.fqdnOrHostName,
        # config.networking.ipAddress,
        # localhost, 127.0.0.1, [1],
        # kube-apiserver + config.kubernetes.etcd.clusterDomain
        # <all> + :<port>
        apiserverCert = secretsPath + "/apiserver.crt";
        apiserverKey = secretsPath + "/apiserver.key";

        # (CA = kubernetes-ca); CN = kube-apiserver-kubelet-client; O = system:masters; L = <any>; S = <any>; C = <any>;
        # kind = client 
        # usage = digital signature, key encipherment, client auth
        kubeletApiCert = secretsPath + "/apiserver-kubelet-client.crt";
        kubeletApiKey = secretsPath + "/apiserver-kubelet-client.key";
        
        # (CA = kubernetes-front-proxy-ca); CN = front-proxy-client; O = system:masters; L = <any>; S = <any>; C = <any>;
        # kind = client 
        # usage = digital signature, key encipherment, client auth
        # Used by            | Key Args                | Cert Args
        # -------------------|-------------------------|---------------------
        # kube-apiserver     | --proxy-client-key-file | --proxy-client-cert-file
        proxyCert = secretsPath + "/front-proxy-client.crt";
        proxyKey = secretsPath + "/front-proxy-client.key";

       # Credentials CA

        # Can be a CA, but is for signing authentication tokens
        # Used by                 | Key Args                           | Cert Args
        # ------------------------|------------------------------------|---------------------
        # kube-controller-manager | --service-account-private-key-file |
        # ------------------------|------------------------------------|---------------------
        # kube-apiserver          |                                    | --service-account-key-file
        # 
        serviceAcctKey = secretsPath + "/sa.key";
        serviceAcctCert = secretsPath + "/sa.pub";

        # Credentials (These are user accounts and therefore should be made with the Kubernetes CA)

        # CN = kubernetes-admin; O = kubeadm:cluster-admins; L = <any>; S = <any>; C = <any>;
        # dataDir + admin.conf -- kubectl
        adminKey = secretsPath + "/admin.key";
        adminCert = secretsPath + "/admin.crt";

        # CN = kubernetes-super-admin; O = system:masters; L = <any>; S = <any>; C = <any>;
        # dataDir + super-admin.confa -- kubectl
        superAdminKey = secretsPath + "/super-admin.key";
        superAdminCert = secretsPath + "/super-admin.crt";

        # CN = system:node: config.networking.fqdnOrHostName; O = system:masters; L = <any>; S = <any>; C = <any>;
        # dataDir + kubelet.conf -- kubelet
        # One required for each node in the cluster
        kubeletCert = secretsPath + "/kubelet.crt";
        kubeletKey = secretsPath + "/kubelet.key";
        
        # CN = system:kube-controller-manager;  O = null; L = <any>; S = <any
        # dataDir + controller-manager.conf -- kube-controller-manager
        # Must be added to manifest in manifests/kube-controller-manager.yaml
        controllerCert = secretsPath + "/controller-manager.crt";
        controllerKey = secretsPath + "/controller-manager.key";

        # CN = system:kube-scheduler;  O = null; L = <any>; S = <any
        # dataDir + scheduler.conf -- kube-scheduler
        # Must be added to manifest in manifests/kube-scheduler.yaml
        schedulerCert = secretsPath + "/scheduler.crt";
        schedulerKey = secretsPath + "/scheduler.key";

        # kubeconfig = {
        #   server = kubeConfigServer;
        #   keyFile = kubeConfigKey;
        #   certFile = kubeConfigCert;
        #   caFile = clusterCA;
        # };
      in {
        roles = ["node"] ++ lib.mkIf cfg.head.self ["master"];
        masterAddress = cfg.head.hostname;
        apiserverAddress = kubeConfigServer;
        easyCerts = true;
        dataDir = dataDir;
        secretsPath = secretsPath;
        clusterCidr = "10.1.0.0/16";
        caFile = clusterCA;

        apiserver = {
          securePort = cfg.head.apiPort;
          advertiseAddress = cfg.head.ipAddress;
          bindAddress = "0.0.0.0";
          clientCaFile = clusterCA;
          etcd = {
            servers = ["http://127.0.0.1:2379"];
            keyFile = etcdApiKey;
            certFile = etcdApiCert;
            caFile = etcdCA;
          };
          kubeletClientCaFile = config.services.kubernetes.kubelet.caFile;
          kubeletClientKeyFile = config.services.kubernetes.kubelet.tlsKeyFile;
          kubeletClientCertFile = config.services.kubernetes.kubelet.tlsCertFile;
          proxyClientCertFile = config.services.kubernetes.proxy.kubeconfig.certFile;
          proxyClientKeyFile = config.services.kubernetes.proxy.kubeconfig.keyFile;
          # Can be null or 0-5 with 5 being the most verbose
          verbosity = 2;
          tokenAuthFile = cfg.tokenFile;
          # This uses the spec defined at https://kubernetes.io/docs/reference/access-authn-authz/webhook/
          webhookConfig = null;
          tlsKeyFile = apiserverKey;
          tlsCertFile = apiserverCert;
          # One of etcd2 or etcd3
          storageBackend = "etcd3";
          serviceClusterIpRange = "10.0.0.0/24";
          serviceAccountSigningKeyFile = serviceAcctKey;
          serviceAccountKeyFile = serviceAcctCert;
          allowPrivileged = true;
          kubeconfig = {
            server = kubeConfigServer;
            keyFile = superAdminKey;
            certFile = superAdminCert;
            caFile = clusterCA;
          };
        };

        scheduler = {
          kubeconfig = {
            server = kubeConfigServer;
            keyFile = schedulerKey;
            certFile = schedulerCert;
            caFile = clusterCA;
          };

          # Can be null or 0-5 with 5 being the most verbose
          verbosity = 2;
          port = 10251;
          leaderElect = true;
          featureGates = null;
          extraOpts = null;
          enable = cfg.head.self;
          address = cfg.head.ipAddress;
        };

        proxy = {
          kubeconfig = {
            server = kubeConfigServer;
            keyFile = proxyKey;
            certFile = proxyCert;
            caFile = clusterCA;
          };

          # Can be null or 0-5 with 5 being the most verbose
          verbosity = 2;
          hostname = config.networking.hostName;
          featureGates = null;
          extraOpts = null;
          enable = cfg.services.kubernetes.services.kube-proxy;
          bindAddress = "0.0.0.0";
        };

        # List of packages to add to the kubernetes path
        path = [];

        package = pkgs.kubernetes;

        kubelet = {
          kubeconfig = {
            server = kubeConfigServer;
            keyFile = kubeletKey;
            certFile = kubeletCert;
            caFile = clusterCA;
          };
          # Can be null or 0-5 with 5 being the most verbose
          verbosity = 2;
          unschedulable = false;
          tlsKeyFile = kubeletApiKey;
          tlsCertFile = kubeletApiCert;
          caFile = clusterCA;
          taints = {};
          seedDockerImages = [
            (pkgs.dockerTools.buildImage {
              name = "pause";
              tag = "latest";
              copyToRoot = pkgs.buildEnv {
                name = "image-root";
                pathsToLink = [ "/bin" ];
                paths = [ top.package.pause ];
              };
              config.Cmd = ["/bin/pause"];
            });
          ];
          registerNode = true;
          port = 10250;
          nodeIp = cfg.ipAddress;
          # List op pod manifests to bootstrap the kubelet with
          manifests = null;
          hostname = config.networking.fqdnOrHostName;
          healthz = {
            port = 10248;
            bind = "127.0.0.1";
          };
          featureGates = config.services.kubernetes.featureGates;
          extraOpts = "";
          enable = true;
          containerRuntimeEndpoint = "unix:///run/containerd/containerd.sock";
          cni = {
            packages = [
              pkgs.cilium-cli
            ];
            configDir = "/etc/cni/net.d";
            config = [
              {
                "cniVersion" = "0.3.1",
                "name" = "cilium",
                "plugins" = [
                  {
                     "type" = "cilium-cni",
                     "enable-debug" = false,
                     "log-file" = "/var/run/cilium/cilium-cni.log"
                  }
                ]
              }
            ];
          };
          clusterDomain = config.services.kubernetes.addons.dns.clusterDomain;
          clusterDns = "10.1.0.1";
          clientCaFile = clusterCA;
          address = "0.0.0.0";
        };

        kubeconfig = {
          server = kubeConfigServer;
          keyFile = adminKey;
          certFile = adminCert;
          caFile = clusterCA;
        };

        flannel = {
          openFirewallPorts = cfg.services.flannel;
          enable = cfg.services.flannel;
        };

        featureGates = [];

        controllerManager = {
          kubeconfig = {
            server = kubeConfigServer;
            keyFile = controllerKey;
            certFile = controllerCert;
            caFile = clusterCA;
          };
          # Can be null or 0-5 with 5 being the most verbose
          verbosity = 2;
          tlsKeyFile = controllerKey;
          tlsCertFile = controllerCert;
          serviceAccountKeyFile = serviceAccountKey;
          securePort = 10257;
          rootCaFile = clusterCA;
          leaderElect = true;
          featureGates = config.services.kubernetes.featureGates;
          extraOpts = "";
          enable = cfg.head.self;
          clusterCidr = onfig.services.kubernetes.clusterCidr;
          bindAddress = "127.0.0.1";
          allocateNodeCIDRs = true;
        };

        # use coredns
        addons.dns.enable = true;
      };
    };

  };
}
