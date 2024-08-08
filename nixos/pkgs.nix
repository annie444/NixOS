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

    # Some networking tools.
    fuse
    fuse3
    sshfs-fuse
    socat
    screen
    tcpdump

    # Hardware-related tools.
    sdparm
    hdparm
    smartmontools # for diagnosing hard disks
    pciutils
    usbutils
    nvme-cli

    # Some compression/archiver tools.
    unzip
    zip
    gnutar
    xz

    w3m # needed for the manual
    testdisk # useful for repairing boot problems
    ms-sys # for writing Microsoft boot sectors / MBRs
    efibootmgr
    efivar
    parted
    gptfdisk
    ddrescue
    ccrypt
    cryptsetup

    # Compilers
    autoconf
    automake
    autobuild
    gnumake
    bison
    bisoncpp
    flex
    pkgconf
    strace
    strace-analyzer
    asciidoc-full-with-plugins
    byacc
    diffstat
    intltool
    jna
    ltrace
    patchutils
    pesign
    sourceHighlight
    pkg-config
    rpm
    rpmextract
    dnf5
    libextractor
    m4
    cmake
    gcc
    gccgo
    gfortran
    libtool
    libedit
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
    ncurses5
    stdenv.cc
    binutils

    # Utilities
    clinfo
    procps
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
  ];
}
