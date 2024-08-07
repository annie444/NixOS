{
  config,
  outputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.zoxide;
in {
  options.profiles.zoxide = {
    enable = mkEnableOption "enable zoxide profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zoxide
    ];
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
