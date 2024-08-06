{ config, inputs, lib, pkgs, meta, ... }:

with lib;

let
  cfg = config.roles.gui;
in {

  options.roles.gui.enable = mkEnableOption "Enable gui services";

  config = mkIf cfg.enable {
    # Setup the GUI here
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
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg = {
      autostart.enable = true;
      icons.enable = true;
      menus.enable = true;
      mime.enable = true;
    };
    
    qt = {
      enable = true;
      platformTheme = "kde";
      style = "kvantum";
    };

    programs.dconf.enable = true;

    environment.sessionVariables = {
      NIX_PROFILES = "${pkgs.lib.concatStringsSep " " (pkgs.lib.reverseList config.environment.profiles)}";
    };

    systemd.defaultUnit = "graphical.target";
    
  };

}
