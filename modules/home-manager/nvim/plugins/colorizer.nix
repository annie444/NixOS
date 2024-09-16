{
  plugins.nvim-colorizer = {
    enable = true;
    fileTypes = {
      css = {
        RGB = true;
        RRGGBB = true;
        names = true;
        RRGGBBAA = true;
        rgb_fn = true;
        hsl_fn = true;
        css = true;
        css_fn = true;
      };
      html = { mode = "background"; };
      markdown = { names = false; };
      "yaml";
      lua = { names = false; };
      "*";
    };
  };
}
