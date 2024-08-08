{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.plasma-browser-integration
    lutris
    nh
    pciutils
    vulkan-tools
    wayland-utils
    xwaylandvideobridge
    (slack.overrideAttrs
       (default: {
         installPhase = default.installPhase + ''
           rm $out/bin/slack

           makeWrapper $out/lib/slack/slack $out/bin/slack \
           --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
           --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
           --add-flags "--enable-features=WebRTCPipeWireCapturer"
         '';
       })
    ) 
  ];
}
