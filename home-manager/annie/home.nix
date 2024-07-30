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
    outputs.homeManagerModules.ssh

    inputs.sops-nix.homeManagerModules.sops

    # You can also split up your configuration and import pieces of it here:
    ./pkgs.nix
    ./programs.nix
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
    age.keyFile = "/home/annie/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/annie/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;
    secrets.publicKey = {
      format = "binary";
      sopsFile = ../../secrets/annie/publickey.gpg.enc;
    };
    secrets."ssh/github/public" = {
      path = "/home/annie/.ssh/github_id25519.pub";
    };
    secrets."ssh/github/private" = {
      path = "/home/annie/.ssh/github_id25519";
    };
    secrets."ssh/ipac/public" = {
      path = "/home/annie/.ssh/ipac_id25519.pub";
    };
    secrets."ssh/ipac/private" = {
      path = "/home/annie/.ssh/ipac_id25519";
    };
    secrets."ssh/homelab/public" = {
      path = "/home/annie/.ssh/jpeg_id25519.pub";
    };
    secrets."ssh/homelab/private" = {
      path = "/home/annie/.ssh/jpeg_id25519";
    };
    secrets."ssh/mayfirst/public" = {
      path = "/home/annie/.ssh/mayfirst_id25519.pub";
    };
    secrets."ssh/mayfirst/private" = {
      path = "/home/annie/.ssh/mayfirst_id25519";
    };
  };

  # Enable my custom profiles
  # NOTE: Make sure each module is imported in the imports section
  profiles.fish.enable = true;
  profiles.tmux.enable = true;
  profiles.nvim.enable = true;

  profiles.ssh = {
    enable = true;
    mayfirstKeyPath = config.sops.secrets."ssh/mayfirst/private".path;
    homelabKeyPath = config.sops.secrets."ssh/homelab/private".path;
    ipacKeyPath = config.sops.secrets."ssh/ipac/private".path;
    githubKeyPath = config.sops.secrets."ssh/github/private".path;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  systemd.user.services.sd-switch.Unit.After = [ "sops-nix.service" ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
