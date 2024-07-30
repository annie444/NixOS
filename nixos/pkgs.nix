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

    # Utilities
    git
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
