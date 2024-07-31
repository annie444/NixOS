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
    (python3.withPackages (python-pkgs: [
      python-pkgs.signedjson
      python-pkgs.pandas
      python-pkgs.requests
      python-pkgs.numpy
      python-pkgs.scipy
      python-pkgs.types-dataclasses
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
