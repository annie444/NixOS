{
  config,
  outputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.direnv;
in {
  options.profiles.direnv = {
    enable = mkEnableOption "enable direnv profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      direnv
    ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
