{
  programs.nixvim.plugins.dressing = {
    enable = true;
    settings = {
      input = {
        enabled = true;
        default_prompt = "➤ ";
        win_options.winblend = 0;
      };
      select = {
        enabled = true;
        backend = ["telescope" "builtin"];
        builtin.win_options.winblend = 0;
      };
    };
  };
}