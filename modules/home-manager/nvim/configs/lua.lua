local function lua_root_dir(fname)
  local root_files = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
  }
  local root = require("lspconfig.util").root_pattern(unpack(root_files))(fname)
  if root and root ~= vim.env.HOME then
    return root
  end
  root = require("lspconfig.util").root_pattern 'lua/'(fname)
  if root then
    return root
  end
  return require("lspconfig.util").find_git_ancestor(fname)
end
