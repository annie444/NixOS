{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.flatpak;
in {
  imports = [];

  options.profiles.flatpak.enable = mkEnableOption "Enable flatpak integration";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      flatpak
      flatpak-builder
    ];
  };
}
