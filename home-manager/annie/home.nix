# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    outputs.homeManagerModules.fish
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.nvim

    inputs.sops-nix.homeManagerModules.sops

    # You can also split up your configuration and import pieces of it here:
    ./pkgs.nix
    # ./fish.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      inputs.neovim-nightly-overlay.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "annie";
    homeDirectory = "/home/annie";
  };

  sops = {
    age = {
      sshKeyPaths = [ "/home/annie/.ssh/jpeg_id25519" ];
      generateKey = true;
    };
    defaultSopsFile = ./annie/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;
    secrets.privatekey = {
      format = "binary";
      sopsFile = "secrets/annie/privatekey.gpg.enc";
    };
  };

  # Enable the k9s program
  programs.k9s.enable = true;

  # Enable my custom profiles
  # NOTE: Make sure each module is imported in the imports section
  profiles.fish.enable = true;
  profiles.tmux.enable = true;
  profiles.nvim.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  systemd.user.services.sd-switch.Unit.After = [ "sops-nix.service" ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
