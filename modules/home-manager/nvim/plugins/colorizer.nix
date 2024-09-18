{
  programs.nixvim.plugins.nvim-colorizer = {
    enable = true;
    fileTypes = [
      {
        language = "css";
        RGB = true;
        RRGGBB = true;
        names = true;
        RRGGBBAA = true;
        rgb_fn = true;
        hsl_fn = true;
        css = true;
        css_fn = true;
      }
      {
        language = "html";
        mode = "background";
      }
      {
        language = "markdown";
        names = false;
      }
      {
        language = "yaml";
      }
      {
        language = "lua";
        names = false;
      }
      {
        language = "*";
      }
    ];
  };
}
