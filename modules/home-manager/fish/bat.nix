{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.bat;
in 
{
  options.profiles.bat = {
    enable = mkEnableOption "enable bat profile";
  };
  config = mkIf cfg.enable {
    programs.bat = {
        enable = true;
        config = {
          theme = "Dracula";
          pager = "less -FR";
          decorations = "always";
          color = "always";
          style = "full";
          map-syntax = [
            "*.ino:C++"
            ".ignore:Git Ignore"
            "*.jenkinsfile:Groovy"
            "*.props:Java Properties"
          ];
        };
        extraPackages = with pkgs.bat-extras; [
          prettybat
          batwatch
          batpipe
          batman
          batgrep
          batdiff
        ];
        themes = {
          dracula = {
            src = pkgs.fetchFromGitHub {
              owner = "dracula";
              repo = "sublime"; # Bat uses sublime syntax for its themes
              rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
              sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
            };
            file = "Dracula.tmTheme";
          };
        };
        syntaxes = {
          gleam = {
            src = pkgs.fetchFromGitHub {
              owner = "molnarmark";
              repo = "sublime-gleam";
              rev = "2e761cdb1a87539d827987f997a20a35efd68aa9";
              hash = "sha256-Zj2DKTcO1t9g18qsNKtpHKElbRSc9nBRE2QBzRn9+qs=";
            };
            file = "syntax/gleam.sublime-syntax";
          };
        };
      };
  };
}
