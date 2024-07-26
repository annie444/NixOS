return {
  'xvzc/chezmoi.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require("chezmoi").setup {
      {
        edit = {
          watch = false,
          force = false,
        },
        notification = {
          on_open = true,
          on_apply = true,
          on_watch = false,
        },
        telescope = {
          select = { "<CR>" },
        },
      }
    }
    local telescope = require("telescope")
    telescope.load_extension('chezmoi')
    vim.keymap.set('n', '<leader>cz', telescope.extensions.chezmoi.find_files, {})
  end
}
