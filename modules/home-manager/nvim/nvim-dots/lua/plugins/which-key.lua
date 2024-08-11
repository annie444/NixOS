return {
  "folke/which-key.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { 'echasnovski/mini.icons', version = false },
  },
  module = true,
  cmd = "WhichKey",
  keys = "<leader>",
  config = function()
    local function toggle_distraction_free()
      if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
        if vim.o.cmdheight ~= 0 or vim.o.laststatus ~= 0 or vim.o.showtabline ~= 0 then
          vim.opt.cmdheight = 0
          vim.opt.laststatus = 0
          vim.opt.showtabline = 0
        else
          vim.opt.cmdheight = 1
          vim.opt.laststatus = 3
          vim.opt.showtabline = 2
        end
      end
    end

    local mappings = {
      { "<leader>r", ":%d+<cr>",              desc = "Remove All Text" },
      { "<leader>y", ":%y+<cr>",              desc = "Yank All Text" },
      { "<leader>e", ":Neotree toggle<cr>",   desc = "Explorer" },
      { "<leader>D", toggle_distraction_free, desc = "Distraction Free" },
      { "<leader>q", ":qa!<cr>",              desc = "Quit" },
      { "<leader>c", ":Bdelete!<cr>",         desc = "Close Buffer" },
      { "<leader>T", ":TSContextToggle<cr>",  desc = "Toggle Context" },
      {
        "<leader>mp",
        function()
          if vim.bo.filetype == "markdown" then
            vim.cmd "MarkdownPreviewToggle"
          else
            vim.notify("Only available in markdown", vim.log.levels.WARN, { title = "Markdown-Preview" })
          end
        end,
        desc = "Markdown Preview",
      },

      { "<leader>p",  group = "Plugin" },
      { "<leader>pc", ":Lazy clean<cr>",   desc = "Clean" },
      { "<leader>pC", ":Lazy check<cr>",   desc = "Check" },
      { "<leader>pd", ":Lazy debug<cr>",   desc = "Debug" },
      { "<leader>pi", ":Lazy install<cr>", desc = "Install" },
      { "<leader>ps", ":Lazy sync<cr>",    desc = "Sync" },
      { "<leader>pl", ":Lazy log<cr>",     desc = "Log" },
      { "<leader>ph", ":Lazy home<cr>",    desc = "Home" },
      { "<leader>pH", ":Lazy help<cr>",    desc = "Help" },
      { "<leader>pp", ":Lazy profile<cr>", desc = "Profile" },
      { "<leader>pu", ":Lazy update<cr>",  desc = "Update" },

      { "<leader>n",  group = "Neovim" },
      { "<leader>nr", ":Reload<cr>",       desc = "Core Reload" },
      { "<leader>nu", ":Update<cr>",       desc = "Update" },
      { "<leader>nm", ":messages<cr>",     desc = "Messages" },
      { "<leader>nh", ":checkhealth<cr>",  desc = "Health" },
      {
        "<leader>nv",
        function()
          local version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
          return vim.notify(version, vim.log.levels.INFO, { title = "Neovim Version" })
        end,
        desc = "Version",
      },
      {
        "<leader>nc",
        config_files,
        desc = "Config Files",
      },
      {
        "<leader>ni",
        function()
          if vim.fn.has "nvim-0.9.0" == 1 then
            vim.cmd "Inspect"
          else
            vim.notify("Inspect isn't available in this neovim version", vim.log.levels.WARN, { title = "Inspect" })
          end
        end,
        desc = "Inspect",
      },

      { "<leader>g",  group = "Git" },
      { "<leader>gj", ":lua require 'gitsigns'.next_hunk()<cr>",       desc = "Next Hunk" },
      { "<leader>gk", ":lua require 'gitsigns'.prev_hunk()<cr>",       desc = "Prev Hunk" },
      { "<leader>gl", ":lua require 'gitsigns'.blame_line()<cr>",      desc = "Blame" },
      { "<leader>gp", ":lua require 'gitsigns'.preview_hunk()<cr>",    desc = "Preview Hunk" },
      { "<leader>gr", ":lua require 'gitsigns'.reset_hunk()<cr>",      desc = "Reset Hunk" },
      { "<leader>gR", ":lua require 'gitsigns'.reset_buffer()<cr>",    desc = "Reset Buffer" },
      { "<leader>gs", ":lua require 'gitsigns'.stage_hunk()<cr>",      desc = "Stage Hunk" },
      { "<leader>gu", ":lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
      { "<leader>go", ":Telescope git_status<cr>",                     desc = "Open changed file" },
      { "<leader>gb", ":Telescope git_branches<cr>",                   desc = "Checkout branch" },
      { "<leader>gc", ":Telescope git_commits<cr>",                    desc = "Checkout commit" },
      {
        "<leader>gd",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd "DiffviewOpen"
          else
            vim.cmd "DiffviewClose"
          end
        end,
        desc = "Toggle Diffview",
      },
      {
        "<leader>gg",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new { cmd = "lazygit" }
          lazygit:toggle()
        end,
        desc = "Lazygit",
      },

      { "<leader>l",  group = "LSP",                                                                    nowait = true,                    noremap = true },
      { "<leader>lf", ":Format<cr>",                                                                    desc = "Format" },
      { "<leader>la", ":Lspsaga code_action<cr>",                                                       desc = "Code Action" },
      { "<leader>li", ":LspInfo<cr>",                                                                   desc = "Info" },
      { "<leader>lo", ":Lspsaga outline<cr>",                                                           desc = "Code Outline" },
      { "<leader>lI", ":Lspsaga incoming_calls<cr>",                                                    desc = "Incoming Calls" },
      { "<leader>lO", ":Lspsaga outgoing_calls<cr>",                                                    desc = "Outgoing Calls" },
      { "<leader>lm", ":Mason<cr>",                                                                     desc = "Mason Installer" },
      { "<leader>lj", ":Lspsaga diagnostic_jump_next<cr>",                                              desc = "Next Diagnostic" },
      { "<leader>lk", ":Lspsaga diagnostic_jump_prev<cr>",                                              desc = "Prev Diagnostic" },
      { "<leader>lr", ":Lspsaga rename<cr>",                                                            desc = "Rename" },
      { "<leader>ld", ":Telescope diagnostics bufnr=0<cr>",                                             desc = "Document Diagnostics" },
      { "<leader>lw", ":Telescope diagnostics<cr>",                                                     desc = "Workspace Diagnostics" },
      { "<leader>ls", ":Telescope lsp_document_symbols<cr>",                                            desc = "Document Symbols" },
      { "<leader>lS", ":Telescope lsp_workspace_symbols<cr>",                                           desc = "Workspace Symbols" },

      { "<leader>f",  group = "Find" },
      { "<leader>fa", ":Telescope autocommands<cr>",                                                    desc = "Autocommmands" },
      { "<leader>ff", ":Telescope find_files<cr>",                                                      desc = "Files" },
      { "<leader>ft", ":Telescope live_grep<cr>",                                                       desc = "Text" },
      { "<leader>fT", ":TodoTelescope<cr>",                                                             desc = "Todo" },
      { "<leader>fB", ":Telescope bookmarks<cr>",                                                       desc = "Browswer Bookmarks" },
      { "<leader>fb", ":Telescope buffers<cr>",                                                         desc = "Buffers" },
      { "<leader>fn", ":lua require('telescope').extensions.notify.notify()<cr>",                       desc = "Notify History" },
      { "<leader>fc", ":Telescope colorscheme<cr>",                                                     desc = "Colorscheme" },
      { "<leader>fp", ":Telescope projects<cr>",                                                        desc = "Projects" },
      { "<leader>fP", "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>", desc = "Colorscheme with Preview" },
      { "<leader>fs", ":Telescope persisted<cr>",                                                       desc = "Sessions" },
      { "<leader>fh", ":Telescope help_tags<cr>",                                                       desc = "Help" },
      { "<leader>fk", ":Telescope keymaps<cr>",                                                         desc = "Keymaps" },
      { "<leader>fC", ":Telescope commands<cr>",                                                        desc = "Commands" },
      { "<leader>fr", ":Telescope oldfiles<cr>",                                                        desc = "Recent Files" },
      { "<leader>fH", ":Telescope highlights<cr>",                                                      desc = "Highlights" },

      { "<leader>t",  group = "Terminal" },
      { "<leader>tt", ":ToggleTerm<cr>",                                                                desc = "Toggle" },
      { "<leader>th", ":ToggleTerm size=10 direction=horizontal<cr>",                                   desc = "Horizontal" },
      { "<leader>tv", ":ToggleTerm size=50 direction=vertical<cr>",                                     desc = "Vertical" },
      { "<leader>tf", ":ToggleTerm direction=float<cr>",                                                desc = "Float" },
    }

    which_key_add(mappings, "n")
  end,
}
