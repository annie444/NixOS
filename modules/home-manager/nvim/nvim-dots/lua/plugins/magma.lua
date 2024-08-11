return {
  "dccsillag/magma-nvim",
  build = "UpdateRemotePlugins",
  lazy = false,
  version = "*",
  keys = {
    { "<leader>ji", "<cmd>MagmaInit<CR>",             desc = "This command initializes a runtime for the current buffer." },
    { "<leader>jo", "<cmd>MagmaEvaluateOperator<CR>", desc = "Evaluate the text given by some operator." },
    { "<leader>jl", "<cmd>MagmaEvaluateLine<CR>",     desc = "Evaluate the current line." },
    { "<leader>jv", "<cmd>MagmaEvaluateVisual<CR>",   desc = "Evaluate the selected text." },
    { "<leader>jc", "<cmd>MagmaEvaluateOperator<CR>", desc = "Reevaluate the currently selected cell." },
    { "<leader>jr", "<cmd>MagmaRestart!<CR>",         desc = "Shuts down and restarts the current kernel." },
    {
      "<leader>jx",
      "<cmd>MagmaInterrupt<CR>",
      desc = "Interrupts the currently running cell and does nothing if not cell is running.",
    },
  },
}
