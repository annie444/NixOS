{
  plugins.flash = {
    enable = true;
    settings = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      multi_window = true;
      forward = true;
      wrap = true;
      mode = "exact";
      incremental = true;
      exclude = [
        "notify"
        "noice"
        "cmp_menu"
        { 
          __raw = ''
            function(win)
              -- exclude non-focusable windows
              return not vim.api.nvim_win_get_config(win).focusable
            end
          '';
        }
      ];
      trigger = "";
    },
    jump = {
      jumplist = true;
      pos = "start";
      history = false;
      register = false;
      nohlsearch = true;
      autojump = false;
    };
    modes = {
      search = {
        enabled = true;
        highlight.backdrop = false;
        jump = { 
          history = true; 
          register = true; 
          nohlsearch = true; 
        };
      };
      char = {
        enabled = false;
        keys = [ "f", "F", "t", "T", "," ];
        search.wrap = false;
        highlight.backdrop = true;
        jump.register = false;
      };
    };
    };
  };
}
