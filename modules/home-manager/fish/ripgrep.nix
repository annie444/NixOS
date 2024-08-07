{
  config,
  outputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.ripgrep;
in {
  options.profiles.ripgrep = {
    enable = mkEnableOption "enable ripgrep profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
    ];
    programs.ripgrep = {
      enable = true;
    };
  };
}
