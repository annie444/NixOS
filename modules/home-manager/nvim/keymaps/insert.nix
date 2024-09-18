{lib, ...}: {
  programs.nixvim.keymaps = lib.lists.forEach [
    {
      key = "<A-j>";
      action = "<Esc>:m .+1<CR>==gi";
      options.desc = "Move the line up";
    }
    {
      key = "<A-k>";
      action = "<Esc>:m .-2<CR>==gi";
      options.desc = "Move the line down";
    }
  ] (k: k // {mode = ["i"];});
}
