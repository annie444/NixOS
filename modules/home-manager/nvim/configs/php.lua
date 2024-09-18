local function php_root_pattern(pattern)
  local cwd = vim.loop.cwd()
  local root = require("lspconfig.util").root_pattern('composer.json', '.git')(pattern)

  -- prefer cwd if root is a descendant
  return require("lspconfig.util").path.is_descendant(cwd, root) and cwd or root
end

local function php_actor_root_dir(pattern)
  local cwd = vim.loop.cwd()
  local root = require("lspconfig.util").root_pattern('composer.json', '.git', '.phpactor.json', '.phpactor.yml')(pattern)

  -- prefer cwd if root is a descendant
  return require("lspconfig.util").path.is_descendant(cwd, root) and cwd or root
end
