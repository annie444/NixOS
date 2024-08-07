{
  lib,
  config,
  pkgs,
  inputs,
  outputs,
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

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # Secrets encryption
    sops
    age
    ssh-to-age

    # home-manager
    inputs.home-manager.packages.${pkgs.system}.default

    # Compilers
    autoconf
    gnumake
    m4
    gcc
    gperf
    libGLU
    libGL
    xorg.libXi
    xorg.libXmu
    xorg.libXext
    xorg.libX11
    xorg.libXv
    xorg.libXrandr
    zlib
    freeglut
    ncurses5
    stdenv.cc
    binutils

    # Utilities
    clinfo
    procps
    unzip
    gnutar
    xz
    glxinfo
    inxi
    tmux-cssh
    nixos-icons
    xdg-utils
    git
    gitRepo
    coreutils-full
    curlFull
    sysstat
    btop
    iotop
    fuse
    tcpdump
    dhcpdump
    ngrep
    nmap
    vim
    nano
    gptfdisk
    inetutils
    gnutls
    busybox
  ];
}
