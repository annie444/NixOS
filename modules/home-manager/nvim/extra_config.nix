{pkgs, ...}: let
  fns = import ./lsp_fns.nix;
  icons = builtins.readFile ./configs/icons.lua;
  noice = builtins.readFile ./configs/noice.lua;
  eslint = builtins.readFile ./configs/eslint.lua;
  go = builtins.readFile ./configs/go.lua;
  java = builtins.readFile ./configs/java.lua;
  ltex = builtins.readFile ./configs/ltex.lua;
  lua = builtins.readFile ./configs/lua.lua;
  markdown = builtins.readFile ./configs/markdown.lua;
  php = builtins.readFile ./configs/php.lua;
  rust = builtins.readFile ./configs/rust.lua;
  tailwind = builtins.readFile ./configs/tailwind.lua;
in {
  programs.nixvim.extraConfigLua =
    ''
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.amber = {
        install_info = {
          url = "${pkgs.treesitter-amber}",
          files = {"src/parser.c"},
          branch = "main",
          generate_requires_npm = true,
          requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
        },
        filetype = "ab",
      }

    ''
    + builtins.concatStringsSep "\n" [
      icons
      noice
      fns.rustRootDir
      eslint
      go
      java
      ltex
      lua
      markdown
      php
      rust
      tailwind
    ];
}
