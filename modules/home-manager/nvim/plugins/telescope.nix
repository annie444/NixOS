{
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native = {
        enable = true;
        settings = {
          fuzzy = true;
          override_generic_sorter = true;
          override_file_sorter = true;
          case_mode = "smart_case";
        };
      };
      ui-select.enable = true;
      file-browser.enable = true;
    };
    settings = {
      defaults = {
        layout_config = {
          width = 0.8;
          height = 0.8;
          prompt_position = "top";
          preview_cutoff = 120;
          horizontal.mirror = false;
          vertical.mirror = false;
        };
        layout_strategy = "horizontal";
        winblend = 0;
        selection_strategy = "reset";
        sorting_strategy = "ascending";
        prompt_prefix = "   ";
        selection_caret = "󰜴 ";
        path_display = ["smart"];
        file_ignore_patterns = [
          ".git/"
          ".git\\"
          "node_modules"
        ];
        mappings = {
          i = {
            "<A-j>" = {
              __raw = "require('telescope.actions').move_selection_next";
            };
            "<A-k>" = {
              __raw = "require('telescope.actions').move_selection_previous";
            };
            "<Tab>" = {
              __raw = "require('telescope.actions').move_selection_next";
            };
            "<S-Tab>" = {
              __raw = "require('telescope.actions').move_selection_previous";
            };
          };
          n = {
            ";" = {
              __raw = "require('telescope.actions').close";
            };
          };
        };
      };
    };
  };
}
