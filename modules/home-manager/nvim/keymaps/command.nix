{
  self,
  lib,
  ...
}: {
  self = lib.lists.forEach [
    {
      key = "<Tab>";
      action.__raw = ''
        function()
          if fn.getcmdtype() == "/" or fn.getcmdtype() == "?" then
            return "<CR>/<C-r>/"
          end
          return "<C-z>"
        end
      '';
      options.desc = "Word Search Increment";
    }
    {
      key = "<S-Tab>";
      action.__raw = ''
        function()
          if fn.getcmdtype() == "/" or fn.getcmdtype() == "?" then
            return "<CR>?<C-r>/"
          end
          return "<S-Tab>"
        end
      '';
      options.desc = "Word Search Decrement";
    }
  ] (k: k // {mode = ["c"];});
}
