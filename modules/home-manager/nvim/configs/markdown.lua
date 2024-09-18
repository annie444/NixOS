local function md_root_dir(fname)
  local root_files = { '.marksman.toml' }
  return require("lspconfig.util").root_pattern(unpack(root_files))(fname) or require("lspconfig.util").find_git_ancestor(fname)
end
