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
    thunderbird
    slack
    _1password
    _1password-gui
    ocs-url

    # for firefox
    speechd
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
