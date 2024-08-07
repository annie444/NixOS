{ config, pkgs, lib, ... }:

let
  # https://github.com/k3s-io/k3s/issues/6518
  containerdTemplate = pkgs.writeText "config.toml.tmpl"
    (builtins.replaceStrings ["@nvidia-container-runtime@"] ["${pkgs.nvidia-k3s}/bin/nvidia-container-runtime"]
      (lib.readFile ./config.toml.tmpl)
    );
in
{
  virtualisation = {
    libvirtd.enable = true;
    lxc.enable = true;
  };

  security.polkit.enable = true;

  environment.systemPackages = [ pkgs.k3s pkgs.iptables ];
  systemd.services.k3s.path = [ pkgs.ipset ];

  # The tmpl needs the full path to the container-shim
  # https://github.com/k3s-io/k3s/issues/6518
  system.activationScripts.writeContainerdConfigTemplate = lib.mkIf (builtins.elem config.networking.hostName [ "homelab01" ]) (lib.stringAfter [ "var" ] ''
    cp ${containerdTemplate} /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
  '');
}
