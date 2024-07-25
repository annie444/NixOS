{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.eza;
in 
{
  options.profiles.eza = {
    enable = mkEnableOption "enable eza profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      eza
    ];
    programs.eza = {
      enable = true;
      extraOptions = [
        "-1"
        "-G"
        "-g"
        "-h"
        "-m"
        "-M"
        "-o"
        "-X"
        "-r"
        "--color=always"
        "-s"
        "created" 
        "--group-directories-first" 
        "--time-style"
        "long-iso"
        "-w"
        "10"
      ];
      icons = true;
      git = true;
    };
  };
}
