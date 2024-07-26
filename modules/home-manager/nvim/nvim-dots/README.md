# NeoVim Dotfiles

These are my personal dotfiles used to configure neovim as a fully-fledged IDE without the overhead of VSCode.

![](https://github.com/annie444/nvim-dots/assets/6550634/16e3bfef-ad2a-4bba-b836-75bfe47b8b39)

## Requirements

Some of these plugins require you to use the Nightly version of neovim. However, I've been able to get them to work reliably with **neovim>=0.9.5** with **LuaJIT>=2.0**. To check your local neovim version, run `nvim -V1 -v`. If your OS doesn't have a recent enough neovim package, you can manually install the latest version in the [neovim repository releases](https://github.com/neovim/neovim/tags).

This repo also relies on lazy.nvim, which should be automatically installed when first launching neovim after installing these dotfiles. However, depending on how neovim was compiled, it may not have the necessary permissions to install lazy.nvim.  In this case, you can manually install lazy.nvim with:

```
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
```

You should also have a working installation of the following runtimes:

- Python 3 (with the pynvim package)
- Ruby
- Perl
- Go
- NodeJS


## Setup

To use these dotfiles, it is recommended to fork this repo before cloning. This will allow you to make your own customizations. After forking the repo, go ahead and clone it into the neovim config directory:

```
git clone https://github.com/<your_username>/nvim-dots.git ~/.config/nvim
```

Before going any further, you'll also need to populate your `options.lua` file at `lua/core/options.lua`. I've included an example of one of mine below.

**NOTE:** The `options.lua` file is not committed to the repo because the paths are often different on each machine.

```lua
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local options = {
  backup = false,         -- creates a backup file
  conceallevel = 2,       -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  hidden = true,          -- required to keep multiple buffers and open multiple buffers
  ignorecase = true,      -- ignore case in search patterns
  mouse = "a",            -- allow the mouse to be used in neovim
  pumheight = 8,          -- pop up menu height
  pumblend = 10,          -- transparency of pop-up menu
  showmode = false,       -- we don't need to see things like -- INSERT -- anymore
  smartcase = true,       -- smart case
  smartindent = true,     -- make indenting smarter again
  splitbelow = true,      -- force all horizontal splits to go below current window
  splitright = true,      -- force all vertical splits to go to the right of current window
  swapfile = true,        -- creates a swapfile
  timeoutlen = 500,       -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,        -- enable persistent undo
  updatetime = 100,       -- faster completion (4000ms default)
  writebackup = false,    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,       -- convert tabs to spaces
  shiftwidth = 2,         -- the number of spaces inserted for each indentation
  tabstop = 2,            -- insert 2 spaces for a tab
  cursorline = true,      -- highlight the current line
  number = true,          -- set numbered lines
  relativenumber = true,  -- set relative numbered lines
  numberwidth = 4,        -- set number column width to 4 {default 4}
  signcolumn = "yes",     -- always show the sign column, otherwise it would shift the text each time
  wrap = false,           -- display lines as one long line
  scrolloff = 8,          -- minimal number of columns to scroll horizontally.
  sidescrolloff = 8,      -- minimal number of screen columns
  lazyredraw = false,     -- Won't be redrawn while executing macros, register and other commands.
  termguicolors = true,   -- Enables 24-bit RGB color in the TUI
  foldenable = true,      -- Enables code folding
  foldlevel = 99,         -- Allows the code folding to encapsulate all children
  foldlevelstart = 99,    -- Allows you to fold any foldable code
  foldmethod = "indent",  -- Uses indentation to determine code foldability
  fillchars = { 
    eob = " ", 
    fold = " ", 
    foldopen = "", 
    foldsep = " ", 
    foldclose = "", 
    lastline = " " 
  }, -- make EndOfBuffer invisible
  foldcolumn = "1",
  ruler = false,
  -- shell = vim.fn.executable "pwsh" and "pwsh" or "powershell",
  -- shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
  -- shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
  -- shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
  -- shellquote = "",
  -- shellxquote = "",
}

local global = {
  mkdp_auto_close = false, -- Don't Exit Preview When Switching Buffers
  tex_compiles_successfully = false, -- This is used to track the state of LaTeX files
  term_pdf_vierer_open = false, -- This is used to track the state of [`termpdf.py'](https://github.com/dsanson/termpdf.py)
  tex_flavor = "latex", -- This can be one of latex, luatex, xelatex
  tex_conceal = "abdmgs", -- I'm not sure what this is, but it's from vimtex's config
  vimtex_quickfix_mode = 0, -- Do not autofix latex files
  vimtex_compiler_latexmk_engines = { ["_"] = "-pdflatex" }, -- Render latex files with pdflatex
  vimtex_view_enabled = 0, -- Do not use VimTex's default viewer
  vimtex_view_automatic = 0, -- Do not automatically open the viewer (mapped to <ctrl-f>)
  vimtex_indent_on_ampersands = 1, -- Make tables legible
  mapleader = " ", -- Set mapleader to space
  vscode_snippets_path = vim.fn.stdpath("config") .. "/snippets/vscode", -- Load the VSCode snippets
  lua_snippets_path = vim.fn.stdpath("config") .. "/lua/custom/lua_snippets", -- Load luaSnips snippets
  magma_image_provider = "kitty", -- Use the [Kitty terminal's](https://sw.kovidgoyal.net/kitty/) image rendering engine
  magma_automatically_open_output = true, -- Automatically open the jupyter console when executing a notebook
  magma_wrap_output = false, -- Do not wrap the output from the jupyter notebook
  magma_output_window_borders = false, -- Do not add extra boarders to the jupyter console
  magma_cell_highlight_group = "CursorLine", -- Highlight only the jupyter cell under the cursor
  magma_save_path = vim.fn.stdpath("data") .. "/magma", -- Keep some state
  vim_svelte_plugin_load_full_syntax = 1, -- Don't be lazy about linting Svelte files
  python3_host_prog = "~/miniforge3/envs/neovim/bin/python", -- path to the Python interpreter with pynvim
  ruby_host_prog = "/usr/bin/ruby", -- path to the ruby interpreter
  node_host_prog = "~/.local/share/nvm/v20.13.0/bin/node", -- path to the NodeJS runtime
  perl_host_prog = "/use/bin/perl", -- path to the perl interpreter
  copilot_assume_mapped = true, -- Don't reapply GitHub Copilot's default mappings
  obsidian_workspaces = { -- List of Obsidian workspaces    {
      name = "Notes",
      path = "~/Documents/Obsidian",
    },
  },
}

vim.opt.shortmess:append "Ac" -- Disable asking when editing file with swapfile.
vim.opt.whichwrap:append "<,>,[,],h,l"
vim.opt.iskeyword:append "-"
vim.lsp.set_log_level("ERROR")

set_option(options)
set_global(global)
```

## Troubleshooting

As always you should always run `:checkhealth` to debug any issues

To access a list of notifications, press <leader>fn

To access the Mason/LSP logs, use the command `:MasonLogs`
