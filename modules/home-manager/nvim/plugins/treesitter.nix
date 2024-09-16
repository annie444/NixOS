{ pkgs, ... }: let 
  ep = include ../extra_plugins;
in {
  treesitter-context = {
    enable = true;
    settings = {
      enable = true;
      max_lines = 0;
      min_window_height = 0;
      line_numbers = true;
      multiline_threshold = 20;
      trim_scope = "outer";
      mode = "cursor";
      zindex = 20;
    };
  };

  treesitter = {
    enable = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars ++ [
      ep.treesitter-amber
      ep.treesitter-just
    ];
    extraConfigLua = ''
      do
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.amber = {
          install_info = {
            url = "${ep.treesitter-amber}", -- local path or git repo
            files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
            branch = "main", -- default branch in case of git repo if different from master
            generate_requires_npm = true, -- if stand-alone parser without npm dependencies
            requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
          },
          filetype = "ab", -- if filetype does not match the parser name
        }
        parser_config.just = {
          install_info = {
            url = "${ep.treesitter-just}", -- local path or git repo
            files = {"src/parser.c", "src/scanner.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
            branch = "main", -- default branch in case of git repo if different from master
            generate_requires_npm = false, -- if stand-alone parser without npm dependencies
            requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
          },
          filetype = "justfile", -- if filetype does not match the parser name
        }
      end
    '';
    settings = {
      sync_install = false;
      auto_install = false;
      highlight.enable = true;
      autopairs.enable = true,
      autotag = {
        enable = true;
        enable_rename = true;
        enable_close = true;
        enable_close_on_slash = true;
        filetypes = [
          "html"
          "javascript"
          "typescript"
          "javascriptreact"
          "typescriptreact"
          "svelte"
          "vue"
          "tsx"
          "jsx"
          "rescript"
          "xml"
          "php"
          "markdown"
          "astro"
          "glimmer"
          "handlebars"
          "hbs"
        ];
        skip_tags = [
          "area"
          "base"
          "br"
          "col"
          "command"
          "embed"
          "hr"
          "img"
          "slot"
          "input"
          "keygen"
          "link"
          "meta"
          "param"
          "source"
          "track"
          "wbr"
          "menuitem"
        ];
      };
      indent.enable = false;
      refactor = {
        highlight_definitions = {
          enable = true;
          clear_on_cursor_move = true;
        };
        highlight_current_scope.enable = true;
        smart_rename = {
          enable = true;
          keymaps.smart_rename = "grr";
        };
        navigation = {
          enable = true;
          keymaps = {
            goto_definition = "gnd";
            list_definitions = "gnD";
            list_definitions_toc = "gO";
            goto_next_usage = "<a-*>";
            goto_previous_usage = "<a-#>";
          };
        };
      };
    };
  };
}
