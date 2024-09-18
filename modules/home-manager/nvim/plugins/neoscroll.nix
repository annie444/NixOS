{
  programs.nixvim.plugins.neoscroll = {
    enable = true;
    settings = {
      mappings = ["<C-u>" "<C-d>" "<C-b>" "<C-f>" "<C-y>" "<C-e>" "zt" "zz" "zb"];
      hide_cursor = true;
      stop_eof = true;
      use_local_scrolloff = false;
      respect_scrolloff = false;
      cursor_scrolls_alone = true;
    };
  };
}
