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
    services.flatpak.enable = true;

    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    home.packages = with pkgs; [
      flatpak
      flatpak-builder
    ];
  };
}
