{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.fzf;
in 
{
  options.profiles.fzf = {
    enable = mkEnableOption "enable fzf profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fzf
    ];
    programs.fzf = {
      enable = true;
      defaultCommand = "bfs . -type f";
      fileWidgetCommand = "bfs . -type f";
      fileWidgetOptions = [ "--preview 'bat {}'" ];
      changeDirWidgetCommand = "bfs . -type d";
      changeDirWidgetOptions = [ "--preview 'tre -C {} | bat -n 200'" ];
      historyWidgetOptions = [ 
        "--sort" 
        "--exact"
        "--preview 'bat -n 20 {}'"
      ];
      colors = {
        fg = "-1";
        bg = "-1";
        hl = "#5fff87";
        "fg+" = "-1";
        "bg+" = "-1";
        "hl+" = "#ffaf5f";
        info = "#af87ff";
        prompt = "#5fff87";
        pointer = "#ff87d7";
        marker = "#ff87d7";
        spinner = "#ff87d7";
      };
      tmux.enableShellIntegration = true;
      enableFishIntegration = true;
    };
  };
}