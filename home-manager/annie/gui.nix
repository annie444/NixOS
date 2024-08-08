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
    ./gui-pkgs.nix
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

  qt = {
    enable = true;
    style.package = pkgs.qt6Packages.qtstyleplugin-kvantum;
    platformTheme.name = "kde";
  };

  services.kdeconnect.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];
      cfg = {
        pipewireSupport = true;
        ffmpegSupport = true;
        gssSupport = true;
        useGlvnd = true;
        alsaSupport = true;
        sndioSupport = true;
        jackSupport = true;
        smartcardSupport = true;
        speechSynthesisSupport = true;
      };
    };
  };
}
