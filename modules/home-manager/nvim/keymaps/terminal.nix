{lib, ...}: {
  programs.nixvim.keymaps = lib.lists.forEach [
    {
      key = "<Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Enter insert mode";
    }
  ] (k: k // {mode = ["t"];});
}
