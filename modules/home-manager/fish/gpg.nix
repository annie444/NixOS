{
  config,
  outputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.gpg;
in {
  options.profiles.gpg = {
    enable = mkEnableOption "enable gpg profile";
  };
  config = mkIf cfg.enable {
    sops.secrets.publicKey = {
      format = "binary";
      sopsFile = ../../../secrets/annie/publickey.gpg.enc;
    };
    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      publicKeys = [
        {
          source = config.sops.secrets.publicKey.path;
          trust = "ultimate";
        }
      ];
    };
    services.gpg-agent = {
      enable = true;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
      pinentryPackage = pkgs.pinentry-curses;
      enableFishIntegration = true;
    };
  };
}
