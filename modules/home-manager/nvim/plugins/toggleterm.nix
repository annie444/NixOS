{ pkgs, ... }: {
  toggleterm = {
    enable = true;
    settings = {
      size = 10;
      open_mapping = "[[<c->]]";
      shade_terminals = true;
      shading_factor = 1;
      start_in_insert = true;
      persist_size = true;
      hide_numbers = true,
      insert_mappings = true;
      direction = "float";
      close_on_exit = true;
      shell = "${pkgs.fish}/bin/fish";
      autochdir = true;
      highlights = {
        NormalFloat = {
          link = "Normal";
        };
        FloatBorder = {
          link = "FloatBorder";
        };
      };
      float_opts = {
        border = "rounded";
        winblend = 0;
      };
    };
  };
}
