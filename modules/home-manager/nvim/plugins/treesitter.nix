{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
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
      grammarPackages =
        pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars
        ++ [
          pkgs.treesitter-amber
          pkgs.treesitter-just
        ];

      settings = {
        sync_install = false;
        auto_install = false;
        highlight.enable = true;
        autopairs.enable = true;
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
            enable = lib.mkForce true;
            clear_on_cursor_move = true;
          };
          highlight_current_scope.enable = lib.mkForce true;
          smart_rename = {
            enable = lib.mkForce true;
            keymaps.smart_rename = "grr";
          };
          navigation = {
            enable = lib.mkForce true;
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
  };
}
