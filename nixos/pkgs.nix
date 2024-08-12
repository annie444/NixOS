{
  lib,
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {

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

    # Application networking tools
    bpftop
    bpfmon
    bpftune
    bpftrace
    bpftools
    bpf-linker
    netop
    sockdump
    pcapc
    ngrep

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
