{
  config,
  outputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.dircolors;
in {
  options.profiles.dircolors = {
    enable = mkEnableOption "enable dircolors profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      coreutils-full
    ];
    programs.dircolors = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
