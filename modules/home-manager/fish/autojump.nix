{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.autojump;
in 
{
  options.profiles.autojump = {
    enable = mkEnableOption "enable autojump profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      autojump
    ];
    programs.autojump = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
