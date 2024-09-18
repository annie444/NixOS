{lib, ...}: {
  programs.nixvim.keymaps = lib.lists.forEach [
    {
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Better Down";
        expr = true;
        silent = true;
      };
    }
    {
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Better Up";
        expr = true;
        silent = true;
      };
    }
    {
      key = "<A-j>";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move the selected text up";
    }
    {
      key = "<A-k>";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move the selected text down";
    }
  ] (k: k // {mode = ["x"];});
}
