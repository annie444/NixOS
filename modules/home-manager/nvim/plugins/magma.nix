{

  magma-nvim = {
    enable = true;
    settings = {
      image_provider = "kitty";
      automatically_open_output = true;
      wrap_output = false;
      output_window_borders = false;
      cell_highlight_group = "CursorLine";
      save_path.__raw = "vim.fn.stdpath(\"data\") .. \"/magma\"";
    };
  };
}
