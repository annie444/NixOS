{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.c
    p.cpp
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.html
    p.java
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.markdown_inline
    p.nix
    p.php
    p.python
    p.regex
    p.rust
    p.scss
    p.svelte
    p.toml
    p.terraform
    p.tsx
    p.typescript
    p.vim
    p.vue
    p.yaml
  ]);

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };

  vale = pkgs.vale.withStyles (s: [
    s.alex
    s.google
    s.joblint
    s.proselint
    s.readability
    s.write-good
  ]);

  lua = pkgs.lua.withPackages (l: [
    l.lua-lsp
    l.luacheck
    l.luarocks
    l.jsregexp
  ]);

  cfg = config.profiles.nvim;
in {
  options.profiles.nvim.enable = mkEnableOption "neovim profile";

  config = mkIf cfg.enable {
    nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default];

    home = {
      packages =
        [
          vale
          lua
        ]
        ++ (with pkgs; [
          antiprism
          cargo
          pnglatex
          mono
          uncrustify
          cpplint
          vim-vint
          lua-language-server
          black
          hadolint
          gitlint
          google-java-format
          ruby
          perl
          efm-langserver
          clang-tools
          pyright
          cbfmt
          actionlint
          yamllint
          elixir-ls
          terraform-ls
          jdt-language-server
          yaml-language-server
          gopls
          lemminx
          cmake
          powershell
          rust-analyzer-unwrapped
          buf-language-server
          buf
          alex
          codespell
          shellcheck
          shfmt

          mercurial
          prettierd
          eslint_d
          golangci-lint-langserver
          golangci-lint
          stylua
          djlint
          markdownlint-cli
          mdformat
          alejandra
          zulu
          julia
          texliveFull
        ])
        ++ (with pkgs.nodePackages_latest; [
          intelephense
          csslint
          typescript-language-server
          svelte-language-server
          svelte-check
          tailwindcss
          stylelint
          prettier
          eslint
          nodejs
        ])
        ++ (with pkgs.php83Packages; [
          php-codesniffer
          composer
        ]);
      file = {
        "./.config/nvim/" = {
          source = ./nvim-dots;
          recursive = true;
        };

        "./.config/nvim/lua/core/options.lua".text = ''
          -- Options are automatically loaded before lazy.nvim startup
          -- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
          -- Add any additional options here

          vim.opt.runtimepath:append("${treesitter-parsers}")

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
            foldenable = true,
            foldlevel = 99,
            foldlevelstart = 99,
            foldmethod = "indent",
            fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " }, -- make EndOfBuffer invisible
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
            tex_compiles_successfully = false,
            term_pdf_vierer_open = false,
            tex_flavor = "latex",
            tex_conceal = "abdmgs",
            vimtex_quickfix_mode = 0,
            vimtex_compiler_latexmk_engines = { ["_"] = "-pdflatex" },
            vimtex_view_enabled = 0,
            vimtex_view_automatic = 0,
            mapleader = " ", -- Set mapleader to space
            vscode_snippets_path = vim.fn.stdpath("config") .. "/snippets/vscode",
            lua_snippets_path = vim.fn.stdpath("config") .. "/lua/custom/lua_snippets",
            magma_image_provider = "kitty",
            magma_automatically_open_output = true,
            magma_wrap_output = false,
            magma_output_window_borders = false,
            magma_cell_highlight_group = "CursorLine",
            magma_save_path = vim.fn.stdpath("data") .. "/magma",
            vim_svelte_plugin_load_full_syntax = 1,
            python3_host_prog = "${pkgs.python311}/bin/python",
            ruby_host_prog = "${pkgs.ruby}/bin/ruby",
            node_host_prog = "${pkgs.nodePackages_latest.nodejs}/bin/node",
            perl_host_prog = "${pkgs.perl}/bin/perl",
            copilot_assume_mapped = true,
            vimwiki_list = { {
              path = '~/Documents/Notes',
              path_html = '~/Documents/Notes/HTML/',
              syntax = 'markdown',
              ext = '.md'
            } },
            vimwiki_url_maxsave = 0,
          }

          vim.opt.shortmess:append "Ac" -- Disable asking when editing file with swapfile.
          vim.opt.whichwrap:append "<,>,[,],h,l"
          vim.opt.iskeyword:append "-"
          vim.lsp.set_log_level("ERROR")

          set_option(options)
          set_global(global)
        '';

        "./.local/share/nvim/nix/nvim-treesitter/" = {
          recursive = true;
          source = treesitterWithGrammars;
        };
      };
    };

    programs.neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withRuby = true;
      withPython3 = true;
      withNodeJs = true;

      coc.enable = false;

      extraPython3Packages = p: [
        p.black
        p.python-lsp-black
        p.flake8
        p.beautysh
        p.flake8-polyfill
        p.autopep8
        p.mdformat
        p.yamllint
        p.pynvim
        p.jupyter-client
        p.ueberzug
        p.pillow
        p.cairosvg
        p.pnglatex
        p.plotly
        p.pip
      ];

      extraLuaPackages = l: [
        l.lua-lsp
        l.luacheck
        l.luarocks
        l.jsregexp
      ];

      extraPackages =
        [
          vale
        ]
        ++ (with pkgs; [
          antiprism
          cargo
          pnglatex
          mono
          uncrustify
          cpplint
          vim-vint
          lua-language-server
          black
          hadolint
          gitlint
          google-java-format
          ruby
          perl
          efm-langserver
          clang-tools
          pyright
          cbfmt
          actionlint
          yamllint
          elixir-ls
          terraform-ls
          jdt-language-server
          yaml-language-server
          gopls
          lemminx
          cmake
          powershell
          rust-analyzer-unwrapped
          buf-language-server
          buf
          alex
          codespell
          shellcheck
          shfmt
          mercurial
          prettierd
          eslint_d
          golangci-lint-langserver
          golangci-lint
          stylua
          djlint
          markdownlint-cli
          mdformat
          alejandra
          zulu
          julia
          texliveFull
        ])
        ++ (with pkgs.nodePackages_latest; [
          intelephense
          csslint
          typescript-language-server
          svelte-language-server
          svelte-check
          tailwindcss
          stylelint
          prettier
          eslint
          nodejs
        ])
        ++ (with pkgs.php83Packages; [
          php-codesniffer
          composer
        ]);

      plugins =
        (with pkgs.vimPlugins; [
          omnisharp-extended-lsp-nvim
        ])
        ++ [treesitterWithGrammars];
    };

    # Treesitter is configured as a locally developed module in lazy.nvim
    # we hardcode a symlink here so that we can refer to it in our lazy config
  };
}
