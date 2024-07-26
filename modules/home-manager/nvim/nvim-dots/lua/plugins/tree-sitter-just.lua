return {
  "IndianBoy42/tree-sitter-just",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    require('tree-sitter-just').setup({})
  end
}
