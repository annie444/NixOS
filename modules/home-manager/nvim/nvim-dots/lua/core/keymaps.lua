-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local fn = vim.fn

local modes = {
  normal_mode = "n",
  insert_mode = "i",
  terminal_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
}

local function close()
  if vim.bo.buftype == "terminal" then
    vim.cmd "Bdelete!"
    vim.cmd "silent! close"
  elseif #vim.api.nvim_list_wins() > 1 then
    vim.cmd "silent! close"
  else
    vim.notify("Can't Close Window", vim.log.levels.WARN, { title = "Close Window" })
  end
end

local function forward_search()
  if fn.getcmdtype() == "/" or fn.getcmdtype() == "?" then
    return "<CR>/<C-r>/"
  end
  return "<C-z>"
end

local function backward_search()
  if fn.getcmdtype() == "/" or fn.getcmdtype() == "?" then
    return "<CR>?<C-r>/"
  end
  return "<S-Tab>"
end



local keymaps = {
  normal_mode = {
    ["<leader>P"] = { cmd = ":lua VimtexPDFToggle()<cr>" },
    ['gau'] = { cmd = function() require('textcase').current_word('to_upper_case') end },
    ['gal'] = { cmd = function() require('textcase').current_word('to_lower_case') end },
    ['gas'] = { cmd = function() require('textcase').current_word('to_snake_case') end },
    ['gad'] = { cmd = function() require('textcase').current_word('to_dash_case') end },
    ['gan'] = { cmd = function() require('textcase').current_word('to_constant_case') end },
    ['gaa'] = { cmd = function() require('textcase').current_word('to_phrase_case') end },
    ['gac'] = { cmd = function() require('textcase').current_word('to_camel_case') end },
    ['gap'] = { cmd = function() require('textcase').current_word('to_pascal_case') end },
    ['gat'] = { cmd = function() require('textcase').current_word('to_title_case') end },
    ['gaf'] = { cmd = function() require('textcase').current_word('to_path_case') end },
    ['gaU'] = { cmd = function() require('textcase').lsp_rename('to_upper_case') end },
    ['gaL'] = { cmd = function() require('textcase').lsp_rename('to_lower_case') end },
    ['gaS'] = { cmd = function() require('textcase').lsp_rename('to_snake_case') end },
    ['gaD'] = { cmd = function() require('textcase').lsp_rename('to_dash_case') end },
    ['gaN'] = { cmd = function() require('textcase').lsp_rename('to_constant_case') end },
    ['gaA'] = { cmd = function() require('textcase').lsp_rename('to_phrase_case') end },
    ['gaC'] = { cmd = function() require('textcase').lsp_rename('to_camel_case') end },
    ['gaP'] = { cmd = function() require('textcase').lsp_rename('to_pascal_case') end },
    ['gaT'] = { cmd = function() require('textcase').lsp_rename('to_title_case') end },
    ['gaF'] = { cmd = function() require('textcase').lsp_rename('to_path_case') end },
    ['geu'] = { cmd = function() require('textcase').operator('to_upper_case') end },
    ['gel'] = { cmd = function() require('textcase').operator('to_lower_case') end },
    ['ges'] = { cmd = function() require('textcase').operator('to_snake_case') end },
    ['ged'] = { cmd = function() require('textcase').operator('to_dash_case') end },
    ['gen'] = { cmd = function() require('textcase').operator('to_constant_case') end },
    ['gea'] = { cmd = function() require('textcase').operator('to_phrase_case') end },
    ['gec'] = { cmd = function() require('textcase').operator('to_camel_case') end },
    ['gep'] = { cmd = function() require('textcase').operator('to_pascal_case') end },
    ['get'] = { cmd = function() require('textcase').operator('to_title_case') end },
    ['gef'] = { cmd = function() require('textcase').operator('to_path_case') end },
    ["<leader>i"] = {
      cmd = ":VimwikiToggleListItem<cr>",
      desc = "Toggle list item"
    },
    ["<leader>k"] = {
      cmd = ":VimwikiIncrementListItem<cr>",
      desc = "Increment list item"
    },
    ["<leader>s"] = {
      cmd = "?#<space><cr>jV}k :sort!<cr>:let @/=''<cr>",
      desc = "Sort list items"
    },
    ["<leader>nl"] = {
      cmd = "Lazy",
      desc = "LazyVim",
    },

    ["<leader>."] = {
      cmd = "lua require('lsp_lines').toggle()",
      desc = "Toggle LSP Lines",
    },

    ["<leader>gg"] = {
      cmd = "LazyGit",
      desc = "LazyGit",
    },

    ["<leader>gj"] = {
      cmd = "LazyGitConfig",
      desc = "LazyGit Config",
    },

    ["<leader>gc"] = {
      cmd = "LazyGitFilterCurrentFile",
      desc = "LazyGit Config Edit",
    },

    ["<leader>jd"] = {
      cmd = "MagmaDeinit",
      desc = "Deinit Magma",
    },

    ["<leader>je"] = {
      cmd = "MagmaEvaluateLine",
      desc = "Evaluate Line",
    },

    ["<leader>jr"] = {
      cmd = "MagmaReevaluateCell",
      desc = "Re evaluate cell",
    },

    ["<leader>jD"] = {
      cmd = "MagmaDelete",
      desc = "Delete cell",
    },

    ["<leader>js"] = {
      cmd = "MagmaShowOutput",
      desc = "Show Output",
    },

    ["<leader>jR"] = {
      cmd = "MagmaRestart!",
      desc = "Restart Magma",
    },

    ["<leader>jS"] = {
      cmd = "MagmaSave",
      desc = "Save",
    },

    ["<leader>Pw"] = {
      cmd = "lua require('swenv').toggle()",
      desc = "Toggle SwEnv",
    },

    ["<leader>Pi"] = {
      cmd = "lua require('swenv.api').pick_venv()",
      desc = "Pick Env",
    },

    ["<leader>Pd"] = {
      cmd = "lua require('swenv.api').get_current_venv()",
      desc = "Show Env",
    },

    ["<F5>"] = {
      cmd = run_code,
      desc = "Run Code",
    },

    -- ["jk"] = {
    --   cmd = "<Esc>",
    --   desc = "Enter insert mode",
    -- },

    ["d"] = {
      cmd = '"_d',
      opt = { remap = false },
      desc = "Delete",
    },

    ["j"] = {
      cmd = "v:count == 0 ? 'gj' : 'j'",
      desc = "Better Down",
      opt = { expr = true, silent = true },
    },

    ["k"] = {
      cmd = "v:count == 0 ? 'gk' : 'k'",
      desc = "Better Up",
      opt = { expr = true, silent = true },
    },

    ["<C-j>"] = {
      cmd = "<C-w>j",
      desc = "Go to upper window",
    },

    ["<C-k>"] = {
      cmd = "<C-w>k",
      desc = "Go to lower window",
    },

    ["<C-h>"] = {
      cmd = "<C-w>h",
      desc = "Go to left window",
    },

    ["<C-l>"] = {
      cmd = "<C-w>l",
      desc = "Go to right window",
    },

    -- ["<Leader>w"] = {
    --   cmd = "<C-w>w",
    --   desc = "Go to next window",
    -- },

    [";"] = {
      cmd = close,
      desc = "Close window",
    },

    ["<C-Up>"] = {
      cmd = ":resize +2<CR>",
      desc = "Add size at the top",
    },

    ["<C-Down>"] = {
      cmd = ":resize -2<CR>",
      desc = "Add size at the bottom",
    },

    ["<C-Left>"] = {
      cmd = ":vertical resize +2<CR>",
      desc = "Add size at the left",
    },

    ["<C-Right>"] = {
      cmd = ":vertical resize -2<CR>",
      desc = "Add size at the right",
    },

    ["H"] = {
      cmd = ":bprevious<CR>",
      desc = "Go to previous buffer",
    },
    ["L"] = {
      cmd = ":bnext<CR>",
      desc = "Go to next buffer",
    },

    ["<Left>"] = {
      cmd = ":tabprevious<CR>",
      desc = "Go to previous tab",
    },

    ["<Right>"] = {
      cmd = ":tabnext<CR>",
      desc = "Go to next tab",
    },

    ["<Up>"] = {
      cmd = ":tabnew<CR>",
      desc = "New tab",
    },

    ["<Down>"] = {
      cmd = ":tabclose<CR>",
      desc = "Close tab",
    },

    ["<A-j>"] = {
      cmd = ":m .+1<CR>==",
      desc = "Move the line up",
    },

    ["<A-k>"] = {
      cmd = ":m .-2<CR>==",
      desc = "Move the line down",
    },
  },
  insert_mode = {

    -- ["jk"] = {
    --   cmd = "<Esc>",
    --   desc = "Enter insert mode",
    -- },

    ["<A-j>"] = {
      cmd = "<Esc>:m .+1<CR>==gi",
      desc = "Move the line up",
    },

    ["<A-k>"] = {
      cmd = "<Esc>:m .-2<CR>==gi",
      desc = "Move the line down",
    },
  },
  terminal_mode = {

    ["<Esc>"] = {
      cmd = "<C-\\><C-n>",
      desc = "Enter insert mode",
    },
  },
  visual_mode = {

    ["<Tab>"] = {
      cmd = ">gv",
      desc = "Indent forward",
    },

    ["<S-Tab>"] = {
      cmd = "<gv",
      desc = "Indent backward",
    },

    ["j"] = {
      cmd = "v:count == 0 ? 'gj' : 'j'",
      desc = "Better Down",
      opt = { expr = true, silent = true },
    },

    ["k"] = {
      cmd = "v:count == 0 ? 'gk' : 'k'",
      desc = "Better Up",
      opt = { expr = true, silent = true },
    },

    ["p"] = {
      cmd = '"_dP',
      desc = "Better Paste",
    },

    -- ["jk"] = {
    --   cmd = "<Esc>",
    --   desc = "Enter insert mode",
    -- },

    ["<"] = {
      cmd = "<gv",
      desc = "Indent backward",
    },

    [">"] = {
      cmd = ">gv",
      desc = "Indent forward",
    },

    ["<A-j>"] = {
      cmd = ":m '>+1<CR>gv=gv",
      desc = "Move the selected text up",
    },

    ["<A-k>"] = {
      cmd = ":m '<-2<CR>gv=gv",
      desc = "Move the selected text down",
    },
  },
  visual_block_mode = {

    ["j"] = {
      cmd = "v:count == 0 ? 'gj' : 'j'",
      desc = "Better Down",
      opt = { expr = true, silent = true },
    },

    ["k"] = {
      cmd = "v:count == 0 ? 'gk' : 'k'",
      desc = "Better Up",
      opt = { expr = true, silent = true },
    },

    ["<A-j>"] = {
      cmd = ":m '>+1<CR>gv=gv",
      desc = "Move the selected text up",
    },

    ["<A-k>"] = {
      cmd = ":m '<-2<CR>gv=gv",
      desc = "Move the selected text down",
    },
  },
  command_mode = {

    ["<Tab>"] = {
      cmd = forward_search,
      desc = "Word Search Increment",
    },

    ["<S-Tab>"] = {
      cmd = backward_search,
      desc = "Word Search Decrement",
    },
  },
}

set_keymaps(keymaps.normal_mode, modes.normal_mode)
set_keymaps(keymaps.insert_mode, modes.insert_mode)
set_keymaps(keymaps.terminal_mode, modes.terminal_mode)
set_keymaps(keymaps.visual_mode, modes.visual_mode)
set_keymaps(keymaps.visual_block_mode, modes.visual_block_mode)
set_keymaps(keymaps.command_mode, modes.command_mode)
