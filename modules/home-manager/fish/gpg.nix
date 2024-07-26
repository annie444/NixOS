{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.gpg;
in 
{
  options.profiles.gpg = {
    enable = mkEnableOption "enable gpg profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnupg
    ];
    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      publicKeys."annie.ehler.4@gmail.com" = {
        source = config.sops.secrets.publicKeys.path;
        trust = "ultimate";
      };
    };
  };
}
