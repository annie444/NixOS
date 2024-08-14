{
  config,
  outputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.ssh;
  onePassPath = "~/.1password/agent.sock";
in {
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
    gui = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether or not custom additions for GUI interoperability should be installed.
      '';
    };
  };
  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages
      ];
      config = {
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
      addKeysToAgent = "yes";
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/%C";
      extraConfig =
        if cfg.gui
        then ''
          Host *
            CanonicalizeHostname yes
            CanonicalDomains ipac.caltech.edu caltech.edu
            CanonicalizeMaxDots 2
            CanonicalizeFallbackLocal yes
            CanonicalizePermittedCNAMEs *.ipac.caltech.edu:ipac.caltech.edu
            IdentityAgent ${onePassPath}
        ''
        else ''
          Host *
            CanonicalizeHostname yes
            CanonicalDomains ipac.caltech.edu caltech.edu
            CanonicalizeMaxDots 2
            CanonicalizeFallbackLocal yes
            CanonicalizePermittedCNAMEs *.ipac.caltech.edu:ipac.caltech.edu
        '';

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
          port = 22;
          identityFile = cfg.homelabKeyPath;
        };
        homelab02 = {
          host = "homelab02";
          hostname = "192.168.4.75";
          user = "annie";
          port = 22;
          identityFile = cfg.homelabKeyPath;
        };
        ipac = {
          port = 22;
          user = "aehler";
          identityFile = cfg.ipacKeyPath;
          forwardAgent = true;
          forwardX11 = true;
          match = "canonical host *.ipac.caltech.edu";
          extraOptions = {
            "Match host neos*" = "\n    User ncmae";
          };
        };
        spinoza = hm.dag.entryAfter ["ipac"] {
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
