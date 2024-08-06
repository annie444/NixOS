{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.plasma-browser-integration
    lutris
    nh
    pciutils
    vulkan-tools
    wayland-utils
    xwaylandvideobridge
  ];
} 
