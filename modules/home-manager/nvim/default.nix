{ config, pkgs, lib, ... }:

with lib;

let cfg = config.profiles.nvim; in {
  options.profiles.nvim.enable = mkEnableOption "neovim profile";

  config = mkIf cfg.enable {
    programs.neovim.enable = true;
  };
}
