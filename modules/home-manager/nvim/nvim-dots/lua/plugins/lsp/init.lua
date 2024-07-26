return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  config = function()
    require("plugins.lsp.handlers").setup()
  end,
  dependencies = {
    {
      "folke/neodev.nvim",
      event = "LspAttach",
      config = function()
        require("neodev").setup {
          library = {
            enabled = true,    -- When not enabled, neodev will not change any settings to the LSP server
            runtime = true,    -- Runtime path
            types = true,      -- Full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
            plugins = true,    -- Installed opt or start plugins in packpath
          },
          setup_jsonls = true, -- Configures jsonls to provide completion for project specific .luarc.json files
          lspconfig = false,
          pathStrict = true,
        }
      end,
    },
    {
      "creativenull/efmls-configs-nvim",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim"
      }
    },
    {
      "williamboman/mason.nvim",
      cmd = {
        "Mason",
        "MasonInstall",
        "MasonUninstall",
        "MasonUninstallAll",
        "MasonLog",
      }, -- Package Manager
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "lukas-reineke/lsp-format.nvim",
      },
      config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")

        require("lspconfig.ui.windows").default_options.border = "rounded"

        local language_servers = {
          "jsonls",
          "lua_ls",
          "clangd",
          "intelephense",
          "cssls",
          "html",
          "tsserver",
          "omnisharp",
          "jdtls",
          "yamlls",
          "gopls",
          "lemminx",
          "vimls",
          "cmake",
          "powershell_es",
          "rust_analyzer",
          "svelte",
          "tailwindcss",
          "bufls",
          "terraformls",
          "elixirls",
          "intelephense",
          "efm",
          "pyright",
        }

        mason.setup {
          ui = {
            -- Whether to automatically check for new versions when opening the :Mason window.
            check_outdated_packages_on_open = true,
            border = "rounded",
            icons = {
              package_pending = " ",
              package_installed = " ",
              package_uninstalled = " ",
            },
          },
        }

        mason_lspconfig.setup {
          ensure_installed = language_servers,
        }

        local disabled_servers = {
          "jdtls",
        }

        mason_lspconfig.setup_handlers {
          function(server_name)
            for _, name in pairs(disabled_servers) do
              if name == server_name then
                return
              end
            end
            local opts = {
              on_attach = require("plugins.lsp.handlers").on_attach,
              capabilities = require("plugins.lsp.handlers").capabilities,
            }

            local require_ok, server = pcall(require, "plugins.lsp.settings." .. server_name)
            if require_ok then
              opts = vim.tbl_deep_extend("force", server, opts)
            end

            lspconfig[server_name].setup(opts)
          end,
        }
      end,
    },
  },
}
