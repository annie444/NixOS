{
  lib,
  config,
  outputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home.packages = with pkgs; [
    # Add your packages here

    # Kubernetes integration
    kubectl
    kubernetes-helm-wrapped
    kustomize
    helmfile-wrapped
    krew
    kubectl-tree
    
    # security stuff
    sops
    age
    ssh-to-age
    openssl
    easyrsa
    (python3.withPackages (p: [
      p.signedjson
      p.pandas
      p.requests
      p.numpy
      p.scipy
      p.types-dataclasses
    ]))
    (terraform.withPlugins (p: [
      p.acme
      p.age
      p.archive
      p.artifactory
      p.cloudflare
      p.cloudinit
      p.dns
      p.dnsimple
      p.docker
      p.elasticsearch
      p.external
      p.gandi
      p.github
      p.gitlab
      p.google
      p.google-beta
      p.grafana
      p.helm
      p.hetznerdns
      p.htpasswd
      p.http
      p.kafka
      p.kafka-connect
      p.keycloak
      p.kubectl
      p.kubernetes
      p.libvirt
      p.linuxbox
      p.local
      p.lxd
      p.mailgun
      p.metal
      p.minio
      p.namecheap
      p.oci
      p.onepassword
      p.pass
      p.porkbun
      p.postgresql
      p.project
      p.proxmox
      p.rabbitmq
      p.rancher2
      p.random
      p.remote
      p.secret
      p.shell
      p.slack
      p.sops
      p.ssh
      p.tailscale
      p.talos
      p.time
      p.tls
      p.utils
      p.vault
    ]))

    # Memory leak detection
    valgrind

    # build tools
    cmake
    gcc
    gnumake
    ninja
    pkg-config

    # generates .cache and compile_commands.json
    # files required by clangd
    bear

    # provides clangd (LSP)
    # provides libraries
    # NOTE: make sure mason.nvim doesn't install clangd
    clang-tools

    # required by codelldb (debugger)
    # lldb # libraries conflicts with clang-tools
    gdb

    # libs
    gpp # c++ module?, decrypt
    gecode # c++ module

  ];
}
