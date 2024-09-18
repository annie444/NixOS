local function tailwind_root_dir(fname)
  return util.root_pattern(
    'tailwind.config.js',
    'tailwind.config.cjs',
    'tailwind.config.mjs',
    'tailwind.config.ts',
    'postcss.config.js',
    'postcss.config.cjs',
    'postcss.config.mjs',
    'postcss.config.ts'
  )(fname) or require("lspconfig.util").find_package_json_ancestor(fname) or require("lspconfig.util").find_node_modules_ancestor(fname) or require("lspconfig.util").find_git_ancestor(
    fname
  )
end

local function tailwind_on_new_config(new_config)
  if not new_config.settings then
    new_config.settings = {}
  end
  if not new_config.settings.editor then
    new_config.settings.editor = {}
  end
  if not new_config.settings.editor.tabSize then
    -- set tab size for hover
    new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
  end
end
