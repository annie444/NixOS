{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # kde packages
    kdePackages.kdeconnect-kde
    kdePackages.plasma-browser-integration

    # Wayland compatibility
    lutris
    nh
    pciutils
    vulkan-tools
    wayland-utils
    xwaylandvideobridge

    # personal apps
    (
      slack.overrideAttrs
      (default: {
        installPhase =
          default.installPhase
          + ''
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
