{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    outputs.homeManagerModules.kitty
  ];

  profiles.kitty.enable = true;

  home.packages = with pkgs; [
    (firefox.override {
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
        pkgs._1password-gui
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
    })
    thunderbird
    slack
    _1password
    _1password-gui
    ocs-url
    speechd-minimal
    opensc
    libjack2
    sndio
    alsa-lib
    libpulseaudio
    libglvnd
    libkrb5
    ffmpeg
    pipewire
  ];
}
