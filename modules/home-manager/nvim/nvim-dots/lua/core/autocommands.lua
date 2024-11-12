-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local fn = vim.fn

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General Settings
local general = augroup("General Settings", { clear = true })


autocmd("BufNewFile", {
  pattern = { "*.md" },
  command = ":r! echo \\# %:t:r",
})

autocmd("BufNewFile", {
  pattern = { "*.md" },
  command = ":norm kddo",
})

--  e.g. ~/.local/share/chezmoi/*
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
  callback = function()
    vim.schedule(require("chezmoi.commands.__edit").watch)
  end,
})

autocmd("VimEnter", {
  callback = function(data)
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    -- change to the directory
    if directory then
      vim.cmd.cd(data.file)
      -- open the tree
      require("neo-tree.command").execute({
        action = "focus",
        source = "filesystem",
        position = "left",
        toggle = true,
        reveal = true,
        dir = data.file
      })
    end
  end,
  group = general,
  desc = "Open NeoTree when it's a Directory",
})

augroup("CustomTex", {})

autocmd("User", {
  group = "CustomTex",
  pattern = "VimtexEventCompileSuccess",
  callback = function()
    vim.g.tex_compiles_successfully = true
    if vim.g.term_pdf_vierer_open and vim.g.tex_compiles_successfully then
      vim.notify("Reloading PDF", vim.log.levels.INFO, { title = "TeX" })
      local kitty = { "kitty", "@", "send-text", "--match", "title:termpdf", vim.g.python3_host_prog,
        "-m", "termpdf", vim.api.nvim_call_function("expand", { "%:r" }) .. ".pdf", '\r' }
      vim.system(kitty)
    end
  end,
})

autocmd("User", {
  group = "CustomTex",
  pattern = "VimtexEventCompileFailed",
  callback = function()
    vim.notify("Pausing PDF reload until successful compilation", vim.log.levels.ERROR, { title = "TeX" })
    vim.g.tex_compiles_successfully = false
  end,
})

autocmd("User", {
  group = "CustomTex",
  pattern = "VimtexEventQuit",
  callback = function()
    vim.notify("Closing PDF viewer", vim.log.levels.WARN, { title = "TeX" })
    vim.system({ "kitty", "@", "close-window", "--match", "title:termpdf" })
  end,
})

-- Disable foldcolumn and statuscolumn in lspsaga outline
autocmd("FileType", {
  pattern = "sagaoutline",
  callback = function()
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.stc = ""
  end,
})

autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    vim.opt.cmdheight = 0
    vim.opt.showtabline = 0
    vim.opt.laststatus = 0

    autocmd("BufUnload", {
      pattern = "<buffer>",
      callback = function()
        vim.opt.cmdheight = 1
        vim.opt.showtabline = 2
        vim.opt.laststatus = 3
      end,
    })
  end,
  desc = "Disable Tabline And StatusLine in Alpha",
})

-- remove this if there's an issue
autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    -- In wsl 2, just install xclip
    -- Ubuntu
    -- sudo apt install xclip
    -- Arch linux
    -- sudo pacman -S xclip
    vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
  end,
  group = general,
  desc = "Lazy load clipboard",
})

autocmd("TermOpen", {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.cmd "startinsert!"
  end,
  group = general,
  desc = "Terminal Options",
})

autocmd("BufReadPost", {
  callback = function()
    if fn.line "'\"" > 1 and fn.line "'\"" <= fn.line "$" then
      vim.cmd 'normal! g`"'
    end
  end,
  group = general,
  desc = "Go To The Last Cursor Position",
})

autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank { higroup = "YankHighlight", timeout = 200 }
  end,
  group = general,
  desc = "Highlight when yanking",
})

autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  group = general,
  desc = "Disable New Line Comment",
})

autocmd("FileType", {
  pattern = { "c", "cpp", "py", "java", "cs" },
  callback = function()
    vim.bo.shiftwidth = 4
  end,
  group = general,
  desc = "Set shiftwidth to 4 in these filetypes",
})

autocmd({ "FocusLost", "BufLeave", "BufWinLeave", "InsertLeave" }, {
  callback = function()
    vim.cmd "silent! w"
  end,
  group = general,
  desc = "Auto Save",
})

autocmd("FocusGained", {
  callback = function()
    vim.cmd "checktime"
  end,
  group = general,
  desc = "Update file when there are changes",
})

autocmd("VimResized", {
  callback = function()
    vim.cmd "wincmd ="
  end,
  group = general,
  desc = "Equalize Splits",
})

autocmd("ModeChanged", {
  callback = function()
    if fn.getcmdtype() == "/" or fn.getcmdtype() == "?" then
      vim.opt.hlsearch = true
    else
      vim.opt.hlsearch = false
    end
  end,
  group = general,
  desc = "Highlighting matched words when searching",
})

autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "text", "log" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  group = general,
  desc = "Enable Wrap in these filetypes",
})
