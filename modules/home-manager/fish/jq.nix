{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.jq;
in 
{
  options.profiles.jq = {
    enable = mkEnableOption "enable jq profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jq
    ];
    programs.jq = {
      enable = true;
    };
  };
}
