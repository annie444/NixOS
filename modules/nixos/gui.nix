{
  config,
  inputs,
  lib,
  pkgs,
  meta,
  ...
}:
with lib; let
  cfg = config.roles.gui;
in {
  options.roles.gui.enable = mkEnableOption "Enable gui services";

  config = mkIf cfg.enable {
    # Setup the GUI here
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];

    services = {
      displayManager = {
        defaultSession = "plasma";
        sddm = {
          enable = true;
          wayland = {
            enable = true;
          };
        };
      };
      desktopManager.plasma6.enable = true;
      libinput.enable = true;
    };

    hardware.pulseaudio.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg = {
      autostart.enable = true;
      icons.enable = true;
      menus.enable = true;
      mime.enable = true;
    };

    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
      setLdLibraryPath = true;
    };

    qt = {
      enable = true;
      platformTheme = "kde";
      style = "kvantum";
    };

    environment.systemPackages = with pkgs; [glxinfo firefox];

    programs.dconf.enable = true;

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = ["annie"];
    };

    systemd.defaultUnit = "graphical.target";
  };
}
