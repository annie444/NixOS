{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.kitty
  ];

  profiles.kitty.enable = true;

  home.packages = with pkgs; [
    thunderbird
    _1password
    _1password-gui
    ocs-url
    google-chrome

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
