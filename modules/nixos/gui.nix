{ config, inputs, lib, pkgs, meta, ... }:

with lib;

let
  cfg = config.roles.gui;
in {

  options.roles.gui.enable = mkEnableOption "Enable gui services";

  config = mkIf cfg.enable {
    # Setup the GUI here
    services.displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        enableHidpi = true;
        autoNumlock = true;
        wayland = {
          enable = true;
        };
      };
    };
    services.desktopManager.plasma6.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    
    qt = {
      enable = true;
      platformTheme = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile = {
      "Kvantum/ArcDark".source = "${pkgs.arc-kde-theme}/share/Kvantum/ArcDark";
      "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ArcDark";
    };

    programs.dconf.enable = true;

    environment.sessionVariables = {
      NIX_PROFILES = "${pkgs.lib.concatStringsSep " " (pkgs.lib.reverseList config.environment.profiles)}";
    };
    
  };

}
