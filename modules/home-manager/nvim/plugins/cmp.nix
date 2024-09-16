{}: let
  windowCompletion = {
    border = "rounded";
    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:Search";
    col_offset = -3;
    side_padding = 1;
    zindex = 1001;
    scrolloff = 0;
  };

  cmdlineConf = {
    mapping = {
      __raw = "require('cmp').mapping.preset.cmdline()";
    };

    sources = [
      { 
        name = "cmdline"; 
      }
      { 
        name = "cmdline_history"; 
      }
      { 
        name = "fuzzy_buffer";
      }
      {
        name = "nvim_lsp_document_symbol";
      }
    ];

    window.completion = windowCompletion;

    formatting.format = {
      __raw = ''
        function(_, vim_item)
          local kind_icons = {
            Text = "󰉿",
            Table = "",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
            Package = "",
            Copilot = "",
            Calendar = "",
            Tag = "",
            Null = "󰟢",
          }
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
          return vim_item
        end
      '';
    };

  };
in {
  cmp-buffer.enable = true;
  cmp-path.enable = true;
  cmp-calc.enable = true;
  cmp-nvim-lsp.enable = true;
  cmp-nvim-lua.enable = true;
  cmp-cmdline.enable = true;
  cmp-cmdline-history.enable = true;
  luasnip = {
    enable = true;
    settings.enable_autosnippets = true;
    filetypeExtend = {
      lua = [
        "c"
        "cpp"
      ];
    };
  };
  friendly-snippets.enable = true;
  cmp-fuzzy-buffer.enable = true;
  cmp-nvim-lsp-signature-help.enable = true;
  cmp-nvim-lsp-document-symbol.enable = true;
  nvim-autopairs = {
    enable = true;
    settings = {
      check_ts = true;
      disable_filetype = [ "TelescopePrompt" ];
    };
  };
  copilot-cmp = {
    enable = true;
    event = [
      "InsertEnter"
      "LspAttach"
    ];
    fixPairs = true;
  };
  crates-nvim.enable = true;

  cmp = {
    enable = true;
    autoEnableSources = false;

    settings = {
      experimental.ghost_text.enabled = true;

      completion = {
        completeopt = "menu,menuone,noselect";
      };

      snippet.expand.__raw = ''
        function(args)
          require("luasnip.loaders.from_vscode").lazy_load()
          require('luasnip').lsp_expand(args.body)
        end
      '';

      mapping.__raw = ''
        requre('cmp').mapping.preset.insert({
          ["<C-k>"] = require('cmp').mapping.select_prev_item(),
          ["<C-j>"] = require('cmp').mapping.select_next_item(),
          ["<C-e>"] = require('cmp').mapping {
            i = require('cmp').mapping.abort(),
            c = require('cmp').mapping.close(),
          },
          ["<CR>"] = require('cmp').mapping.confirm({ select = false }),
          ["<C-Space>"] = require('cmp').mapping.complete(),
          ["<C-f>"] = require('cmp').mapping(require('cmp').mapping.scroll_docs(1)),
          ["<C-b>"] = require('cmp').mapping(require('cmp').mapping.scroll_docs(-1)),
          ["<C-u>"] = require('cmp').mapping.scroll_docs(-4),
          ["<C-d>"] = require('cmp').mapping.scroll_docs(4),
          ["<Tab>"] = require('cmp').mapping(function(fallback)
            local has_words_before = function()
              if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
                return false
              end
              local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
            end
            if require('cmp').visible() and has_words_before() then
              require('cmp').select_next_item { behavior = require('cmp').SelectBehavior.Select }
            elseif require('cmp').visible() then
              require('cmp').select_next_item()
            elseif require('luasnip').expandable() then
              require('luasnip').expand()
            elseif require('luasnip').expand_or_jumpable() then
              require('luasnip').expand_or_jump()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
          ["<S-Tab>"] = require('cmp').mapping(function(fallback)
            if require('cmp').visible() then
              require('cmp').select_prev_item()
            elseif require('luasnip').jumpable(-1) then
              require('luasnip').jump(-1)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        })
      '';

      formatting.format.__raw = ''
        function(_, vim_item)
          local kind_icons = {
            Text = "󰉿",
            Table = "",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
            Package = "",
            Copilot = "",
            Calendar = "",
            Tag = "",
            Null = "󰟢",
          }
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
          return vim_item
        end
      '';

      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "nvim_lsp_signature_help"; }
        { name = "copilot"; },
        { name = "nvim_lua"; },
        { name = "luasnip"; },
        { name = "cmdline"; },
        { name = "cmdline_history"; },
        { name = "fuzzy_buffer"; }
      ];

      sorting = {
        priority_weight = 2;
        comparators.__raw = ''
          require("copilot_cmp.comparators").prioritize,
        '';
      };

      window = {
        completion = windowCompletion;
        documentation = windowCompletion;
      };
    };

    cmdline = {
      ":" = cmdlineConf;
      "/" = cmdlineConf; 
      "?" = cmdlineConf; 
      "@" = cmdlineConf;
    };
  };
}
