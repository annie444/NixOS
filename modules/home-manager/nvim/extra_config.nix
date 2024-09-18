{pkgs, ...}: {
  programs.nixvim.extraConfigLua = ''
    local icons = require('nvim-web-devicons')
    icons.set_icon {
      deb = { icon = "", name = "Deb", color = "#A1B7EE" },
      lock = { icon = "", name = "Lock", color = "#C4C720" },
      mp3 = { icon = "󰈣", name = "Mp3", color = "#D39EDE" },
      mp4 = { icon = "", name = "Mp4", color = "#9EA3DE" },
      out = { icon = "󰈚", name = "Out", color = "#ABB2BF" },
      ["robots.txt"] = { icon = "󱜙", name = "Robots", "#ABB2BF" },
      [""] = { icon = "󰈚", name = "default", "#ABB2Bf" },
      norg = { icon = "󰈚", name = "default", "#ABB2Bf" },
      ttf = { icon = "", name = "TrueTypeFont", "#ABB2Bf" },
      rpm = { icon = "", name = "Rpm", "#FCA2Aa" },
      woff = { icon = "", name = "WebOpenFontFormat", color = "#ABB2Bf" },
      woff2 = { icon = "", name = "WebOpenFontFormat2", color = "#ABB2Bf" },
      xz = { icon = "", name = "Xz", color = "#519ABa" },
      zip = { icon = "", name = "Zip", color = "#F9D71c" },
      snippets = { icon = "", name = "Snippets", color = "#51AFEf" },
      ahk = { icon = "󰈚", name = "AutoHotkey", color = "#51AFEf" },
    }

    require('noice').setup({
      lsp = {
        progress = {
          enabled = false,
          -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
          -- See the section on formatting for more details on how to customize.
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle = 1000 / 30, -- frequency to update lsp progress message
          view = "mini",
        },
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = false,
          silent = false, -- set to true to not show a message if hover is not available
          view = nil,     -- when nil, use defaults from documentation
          opts = {},      -- merged with defaults from documentation
        },
        signature = {
          enabled = false,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50,  -- Debounce lsp signature help request by 50ms
          },
          view = nil,       -- when nil, use defaults from documentation
          opts = {},        -- merged with defaults from documentation
        },
        message = {
          -- Messages shown by lsp servers
          enabled = true,
          view = "notify",
          opts = {},
        },
        -- defaults for hover and signature help
        documentation = {
          view = "hover",
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },
      presets = {
        -- you can enable a preset by setting it to true, or a table that will override the preset config
        -- you can also add custom presets that you can enable/disable with enabled=true
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    })

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.amber = {
      install_info = {
        url = "${pkgs.treesitter-amber}", -- local path or git repo
        files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = true, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
      },
      filetype = "ab", -- if filetype does not match the parser name
    }

  '';
}
