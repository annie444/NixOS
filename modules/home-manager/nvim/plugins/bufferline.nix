{
  bufferline = {
    enable = true;
    settings = {
      options = {
        mode = "buffers";
        close_command = ":Bdelete!";
        right_mouse_command = ":Bdelete!";
        offsets = [
          {
            filetype = "NvimTree";
            text = "File Explorer";
            highlight = "Directory";
            padding = 1;
          }
          {
            filetype = "sagaoutline";
            text = "Code Outline";
            highlight = "Directory";
            padding = 1;
          }
        ];
        indicator = {
          icon = "▎";
        };
        always_show_bufferline = false;
        buffer_close_icon = "";
        modified_icon = "●";
        close_icon = "";
        left_trunc_marker = "";
        right_trunc_marker = "";
        max_name_length = 18;
        max_prefix_length = 15;
        tab_size = 18;
      };
      highlights = {
        buffer_selected = {
          bold = false;
          italic = false;
        };
        tab_selected = {
          bold = false;
          italic = false;
        };
      };
    };
  };
}
