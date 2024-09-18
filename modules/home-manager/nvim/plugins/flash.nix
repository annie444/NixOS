{
  programs.nixvim.plugins.flash = {
    enable = true;
    settings = {
      labels = "asdfghjklqwertyuiopzxcvbnm";
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
      };
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
          keys = {
            __unkeyed-0 = "f";
            __unkeyed-1 = "F";
            __unkeyed-2 = "t";
            __unkeyed-3 = "T";
            __unkeyed-4 = ";";
            __unkeyed-5 = ",";
          };
          search.wrap = false;
          highlight.backdrop = true;
          jump.register = false;
        };
      };
    };
  };
}
