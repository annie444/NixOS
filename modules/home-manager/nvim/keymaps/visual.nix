{
  self,
  lib,
  ...
}: {
  self = lib.lists.forEach [
    {
      key = "<Tab>";
      action = ">gv";
      desc = "Indent forward";
    }
    {
      key = "<S-Tab>";
      action = "<gv";
      desc = "Indent backward";
    }
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
      key = "p";
      action = "\"_dP";
      options.desc = "Better Paste";
    }
    {
      key = "<";
      action = "<gv";
      options.desc = "Indent backward";
    }
    {
      key = ">";
      action = ">gv";
      options.desc = "Indent forward";
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
  ] (k: k // {mode = ["v"];});
}
