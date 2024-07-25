{ config, pkgs, lib, ... }:

with lib;

let cfg = config.profiles.nvim; in {
  options.profiles.nvim = {
    enable = mkEnableOption "neovim profile";
    package = mkOption {
      type = types.package;
      default = pkgs.neovim;
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      package = cfg.package;
    };
  };
}
