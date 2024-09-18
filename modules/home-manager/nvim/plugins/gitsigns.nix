{
  programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = {
          hl = "GitSignsAdd";
          text = "▎";
          numhl = "GitSignsAddNr";
          linehl = "GitSignsAddLn";
        };
        change = {
          hl = "GitSignsChange";
          text = "▎";
          numhl = "GitSignsChangeNr";
          linehl = "GitSignsChangeLn";
        };
        delete = {
          hl = "GitSignsDelete";
          text = "";
          numhl = "GitSignsDeleteNr";
          linehl = "GitSignsDeleteLn";
        };
        topdelete = {
          hl = "GitSignsDelete";
          text = "";
          numhl = "GitSignsDeleteNr";
          linehl = "GitSignsDeleteLn";
        };
        changedelete = {
          hl = "GitSignsChange";
          text = "▎";
          numhl = "GitSignsChangeNr";
          linehl = "GitSignsChangeLn";
        };
        untracked.text = "▎";
      };
      signcolumn = true; # Toggle with `:Gitsigns toggle_signs`
      numhl = false; # Toggle with `:Gitsigns toggle_numhl`
      linehl = false; # Toggle with `:Gitsigns toggle_linehl`
      word_diff = false; # Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir.follow_files = true;
      attach_to_untracked = true;
      current_line_blame = false;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 1000;
        ignore_whitespace = false;
      };
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>";
      sign_priority = 6;
      update_debounce = 100;
      max_file_length = 40000;
      preview_config = {
        border = "rounded";
        style = "minimal";
        relative = "cursor";
        row = 0;
        col = 1;
      };
    };
  };
}
