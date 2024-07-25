{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.autojump;
in 
{
  options.profiles.tealdeer = {
    enable = mkEnableOption "enable tealdeer profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tealdeer
    ];
    programs.tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };
  };
}
