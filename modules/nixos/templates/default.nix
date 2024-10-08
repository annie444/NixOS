{
  imports = [
    ./apps/modern-unix.nix
    ./apps/monitoring-tools.nix
    ./hardware/nvidia.nix
    ./services/k3s
    ./services/kvm.nix
    ./services/nvidia-docker.nix
    ./services/printer.nix
    ./services/samba.nix
    ./services/smartd-webui.nix
    ./services/ssh.nix
    ./services/vsftpd.nix
    ./services/podman.nix
    ./services/docker.nix
    ./services/tailscale.nix
    ./system/desktop.nix
    ./system/grub.nix
  ];
}
