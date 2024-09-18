{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.profiles.nvim;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./auto_cmd.nix
    ./globals.nix
    ./keymaps
    ./opts.nix
    ./auto_groups.nix
    ./extra_config.nix
    ./colorschemes.nix
    ./plugins
  ];

  options.profiles.nvim.enable = lib.mkEnableOption "neovim profile";

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      enableMan = true;
      extraConfigVim = ''
        set spell
        syntax enable
        filetype plugin indent on
        set modeline
        set modelines=5
      '';
      performance = {
        combinePlugins.enable = true;
        byteCompileLua = {
          enable = true;
          configs = true;
          initLua = true;
          nvimRuntime = true;
          plugins = true;
        };
      };
      luaLoader.enable = true;
      editorconfig.enable = true;
      clipboard.providers.wl-copy.enable = true;
      extraPlugins = [
        pkgs.vimPlugins.plenary-nvim
        pkgs.vimPlugins.neodev-nvim
        pkgs.vimPlugins.nui-nvim
        pkgs.treesitter-amber
        pkgs.noice
      ];
    };
  };
}
