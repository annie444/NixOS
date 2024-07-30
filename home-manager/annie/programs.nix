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

  programs = {
    man.enable = true;
    command-not-found.enable = true;
    k9s.enable = true;
    home-manager.enable = true;
    git.enable = true;
    bcc.enable = true;
    benchexec = {
      enable = true;
      users = [ "annie" ];
    };
    cpu-energy-meter.enable = true;
    ecryptfs.enable = true;
    htop.enable = true;
    iftop.enable = true;
    iotopt.enable = true;
    lazygit.enable = true;
    less.enable = true;
    npm.enable = true;
    rust-motd.enable = true;
    traceroute.enable = true;
  }
}
