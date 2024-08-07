{ config, pkgs, lib, ... }:

let
  cfg = config.roles.nvidia-graphics;
in
{

  options.roles.nvidia-graphics.enable = lib.mkEnableOption "Enable NVIDIA graphics support";

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}
