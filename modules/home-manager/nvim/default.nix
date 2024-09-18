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
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      withRuby = true;
      colorscheme = "dracula";

      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

      extraConfigVim = ''
        set spell
        syntax enable
        filetype plugin indent on
        set modeline
        set modelines=5
      '';

      performance.combinePlugins.enable = false;

      # performance = {
      #   byteCompileLua = {
      #     enable = true;
      #     initLua = true;
      #     plugins = true;
      #   };
      # };

      luaLoader.enable = true;
      editorconfig.enable = true;
      clipboard.providers.wl-copy.enable = true;

      extraPlugins = [
        pkgs.unstable.vimPlugins.plenary-nvim
        pkgs.unstable.vimPlugins.neodev-nvim
        pkgs.unstable.vimPlugins.nui-nvim
        pkgs.treesitter-amber
        pkgs.unstable.vimPlugins.noice-nvim
      ];

      extraPython3Packages = p: [
        p.ipykernel
        p.ipywidgets
        p.ipycanvas
        p.ipython
        p.ipyparallel
        p.pynvim
        p.jupyter-client
        p.ueberzug
        p.pillow
        p.cairosvg
        p.pnglatex
        p.plotly
        p.pyperclip
      ];
    };
  };
}
