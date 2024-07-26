return {
  "zbirenbaum/copilot-cmp",
  init = function()
    require("copilot_cmp").setup()
  end,
  event = { "InsertEnter", "LspAttach" },
}
