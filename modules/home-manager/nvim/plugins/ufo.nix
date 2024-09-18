{
  programs.nixvim.plugins.nvim-ufo = {
    enable = true;
    providerSelector.__raw = ''
      function(_, _, _)
        return { "treesitter", "indent" }
      end
    '';
  };
}
