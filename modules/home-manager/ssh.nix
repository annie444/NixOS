{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.ssh;
in
{
  
  options.profiles.ssh = {
    enable = mkEnableOption "enable ssh profile";
    mayfirstKeyPath = mkOption {
      type = types.path;
      default = "~/.ssh/mayfirst_id_ed25519";
      description = ''
      Path to the ssh key for mayfirst.
      '';
    };
    homelabKeyPath = mkOption {
      type = types.path;
      default = "~/.ssh/jpec_id_ed25519";
      description = ''
      Path to the ssh key for the homelab.
      '';
    };
    ipacKeyPath = mkOption {
      type = types.path;
      default = "~/.ssh/ipac_id_ed25519";
      description = ''
      Path to the ssh key for IPAC.
      '';
    };
    githubKeyPath = mkOption {
      type = types.path;
      default = "~/.ssh/github_id_ed25519";
      description = ''
      Path to the ssh key for GitHub.
      '';
    };
  };
  config = mkIf cfg.enable {

    nixpkgs = {
      # You can add overlays here
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages

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

    programs.ssh = {

      enable = true;
      forwardAgent = false;
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/%C";

      matchBlocks = {
        mayfirst = {
          host = "mayfirst";
          hostname = "shell.mayfirst.org";
          user = "annie444";
          port = 22;
          identityFile = cfg.mayfirstKeyPath;
        };
        homelab01 = {
          host = "homelab01";
          hostname = "192.168.4.72";
          user = "annie";
          port =  22;
          identityFile = cfg.homelabKeyPath;
        };
        homelab02 = {
          host = "homelab02";
          hostname = "192.168.4.75";
          user = "annie";
          port =  22;
          identityFile = cfg.homelabKeyPath;
        };
        ipac = {
          port = 22;
          user = "aehler";
          identityFile = cfg.ipacKeyPath;
          forwardAgent = true;
          forwardX11 = true;
          match = "canonical host *.ipac.caltech.edu";
        };
        neos = {
          host = "neo*,ncm*";
          user = "ncmae";
        };
        spinoza = {
          host = "spinoza";
          hostname = "spinoza.ipac.caltech.edu";
          port = 22;
          user = "annie";
          identityFile = cfg.ipacKeyPath;
        };
        github = {
          host = "github.com";
          hostname = "github.com";
          identityFile = cfg.githubKeyPath;
        };
        gist = {
          host = "gist.github.com";
          hostname = "gist.github.com";
          identityFile = cfg.githubKeyPath;
        };
      };
    };
  };
}
