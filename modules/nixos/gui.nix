{ config, inputs, lib, pkgs, meta, ... }:

with lib;

let
  cfg = config.roles.gui;
in {
  imports = [
    inputs._1password-shell-plugins.hmModules.default
  ];

  options.roles.gui.enable = mkEnableOption "Enable gui services";

  config = mkIf cfg.enable {
    # Setup the GUI here

    environment.systemPackages = with pkgs; [
      # 1Password
      _1password
      _1password-gui
    ];

    programs._1password-shell-plugins = {
      # enable 1Password shell plugins for bash, zsh, and fish shell
      enable = true;
      # the specified packages as well as 1Password CLI will be
      # automatically installed and configured to use shell plugins
      plugins = with pkgs; [ gh ];
    };
    
  };

}
