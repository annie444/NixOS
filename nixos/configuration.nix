# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    outputs.nixosModules.templates

    ./users.nix
    ./pkgs.nix
  ];

  networking.firewall.enable = false;

  templates = {
    apps = {
      modernUnix.enable = true;
      monitoring.enable = true;
    };
    services = {
      ssh.enable = true;
    };
  };

  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-24.05";
  };

  programs.mosh.enable = true;
}
