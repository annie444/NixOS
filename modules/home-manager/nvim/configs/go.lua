local function go_root_pattern(fname)
  return require("lspconfig.util").root_pattern(
    '.golangci.yml',
    '.golangci.yaml',
    '.golangci.toml',
    '.golangci.json',
    'go.work',
    'go.mod',
    '.git'
  )(fname)
end

local function gopls_root_pattern(fname)
  -- see: https://github.com/neovim/nvim-lspconfig/issues/804
  if not mod_cache then
    local result = require("lspconfig.async").run_command { 'go', 'env', 'GOMODCACHE' }
    if result and result[1] then
      mod_cache = vim.trim(result[1])
    end
  end
  if fname:sub(1, #mod_cache) == mod_cache then
    local clients = require("lspconfig.util").get_lsp_clients { name = 'gopls' }
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return require("lspconfig.util").root_pattern('go.work', 'go.mod', '.git')(fname)
end
