-- NOTE: Check out this for guide
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
return {
  "mfussenegger/nvim-dap",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"
    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    -- dap.listeners.before.event_terminated["dapui_config"] = function()
    --   dapui.close()
    -- end

    -- dap.listeners.before.event_exited["dapui_config"] = function()
    --   dapui.close()
    -- end

    -- NOTE: Make sure to install the needed files/exectubles through mason
    require "plugins.dap.cpptools"
    require "plugins.dap.java-debug"
    require "plugins.dap.node-debug2"
    require "plugins.dap.debugpy"
    require "plugins.dap.delve"
    require "plugins.dap.js-debug"
    local mappings = {
      { "<leader>d",  group = "Dap",                               nowait = true,      remap = false },
      { "<leader>dc", ":lua require'dap'.continue()<cr>",          desc = "Continue",  nowait = true, remap = false },
      { "<leader>do", ":lua require'dap'.step_over()<cr>",         desc = "Step Over" },
      { "<leader>di", ":lua require'dap'.step_into()<cr>",         desc = "Step Into" },
      { "<leader>du", ":lua require'dap'.step_out()<cr>",          desc = "Step Out" },
      { "<leader>db", ":lua require'dap'.toggle_breakpoint()<cr>", desc = "Breakpoint" },
      { "<leader>dd", ":lua require'dapui'.toggle()<cr>",          desc = "Dap UI" },
    }
    which_key_add(mappings, "n")
  end,
  dependencies = {
    { "nvim-neotest/nvim-nio" },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      config = function()
        require("dapui").setup {
          layouts = {
            {
              elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "breakpoints",
                "stacks",
                "watches",
              },
              size = 40, -- 40 columns
              position = "left",
            },
            {
              elements = {
                "repl",
                "console",
              },
              size = 0.25, -- 25% of total lines
              position = "bottom",
            },
          },
        }
      end,
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      config = function()
        local debug_adapters = {
          "chrome-debug-adapter",
          "firefox-dubug-adapter",
          "codelldb",
          "cpptools",
          "debugpy",
          "go-debug-adapter",
          "js-debug-adapter",
          "php-debug-adapter"
        }
        require('mason-nvim-dap').setup({
          ensure_installed = debug_adapters,
          handlers = {}, -- sets up dap in the predefined manner
        })
      end,
    },
    "williamboman/mason.nvim",
  },
}
