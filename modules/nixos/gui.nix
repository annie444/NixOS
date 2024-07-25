{ config, lib, pkgs, meta, ... }:

with lib;

let
  cfg = config.roles.gui;
in {
  options.roles.gui.enable = mkEnableOption "Enable gui services";

  config = mkIf cfg.enable {
    # Setup the GUI here
    
  };

}
