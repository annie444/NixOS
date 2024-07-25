{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.thefuck;
in 
{
  options.profiles.thefuck = {
    enable = mkEnableOption "enable thefuck profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thefuck
    ];
    programs.thefuck = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
