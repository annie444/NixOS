{
  nvim-ufo = {
    enable = true;
    provider_selector.__raw = ''
      function(_, _, _)
        return { "treesitter", "indent" }
      end
    '';
  };
}
