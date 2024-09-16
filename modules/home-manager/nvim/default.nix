{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  extraConfigs = import ./extra_configs;
  extraPlugins = import ./extra_plugins;
  cfg = config.profiles.nvim;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  options.profiles.nvim.enable = mkEnableOption "neovim profile";

  config = mkIf cfg.enable {
    nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default];

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
      extraConfigLua = ''
        local icons = require('nvim-web-devicons')
        icons.set_icon {
          deb = { icon = "", name = "Deb", color = "#A1B7EE" },
          lock = { icon = "", name = "Lock", color = "#C4C720" },
          mp3 = { icon = "󰈣", name = "Mp3", color = "#D39EDE" },
          mp4 = { icon = "", name = "Mp4", color = "#9EA3DE" },
          out = { icon = "󰈚", name = "Out", color = "#ABB2BF" },
          ["robots.txt"] = { icon = "󱜙", name = "Robots", "#ABB2BF" },
          [""] = { icon = "󰈚", name = "default", "#ABB2Bf" },
          norg = { icon = "󰈚", name = "default", "#ABB2Bf" },
          ttf = { icon = "", name = "TrueTypeFont", "#ABB2Bf" },
          rpm = { icon = "", name = "Rpm", "#FCA2Aa" },
          woff = { icon = "", name = "WebOpenFontFormat", color = "#ABB2Bf" },
          woff2 = { icon = "", name = "WebOpenFontFormat2", color = "#ABB2Bf" },
          xz = { icon = "", name = "Xz", color = "#519ABa" },
          zip = { icon = "", name = "Zip", color = "#F9D71c" },
          snippets = { icon = "", name = "Snippets", color = "#51AFEf" },
          ahk = { icon = "󰈚", name = "AutoHotkey", color = "#51AFEf" },
        }
      '' ++ extraConfigs.noice;
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
      opts = import ./opts.nix;
      extraPlugins = [
        pkgs.vimPlugins.plenary-nvim
        pkgs.vimPlugins.neodev-nvim
        pkgs.vimPlugins.nui-nvim
        extraPlugins.treesitter-amber
        extraPlugins.treesitter-just
        extraPlugins. noice
      ];
      plugins = import ./plugins;
      colorschemes = import ./colorschemes.nix;
      autoCmd = import ./auto_cmd.nix;
      autoGroups = import ./auto_groups.nix;
      extraFiles = import ./extra_files;
      highlight = import ./highlight.nix;
      globals = import ./globals.nix;
      keymaps = import ./keymaps;
    };
  };
}
