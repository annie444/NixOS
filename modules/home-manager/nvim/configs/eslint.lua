
local function eslint_root_dir(fname)
  root_file = require("lspconfig.util").insert_package_json(root_file, 'eslintConfig', fname)
  return require("lspconfig.util").root_pattern(unpack(root_file))(fname)
end

local function on_new_config(config, new_root_dir)
  -- The "workspaceFolder" is a VSCode concept. It limits how far the
  -- server will traverse the file system when locating the ESLint config
  -- file (e.g., .eslintrc).
  config.settings.workspaceFolder = {
    uri = new_root_dir,
    name = vim.fn.fnamemodify(new_root_dir, ':t'),
  }
  -- Support flat config
  if
    vim.fn.filereadable(new_root_dir .. '/eslint.config.js') == 1
    or vim.fn.filereadable(new_root_dir .. '/eslint.config.mjs') == 1
    or vim.fn.filereadable(new_root_dir .. '/eslint.config.cjs') == 1
    or vim.fn.filereadable(new_root_dir .. '/eslint.config.ts') == 1
    or vim.fn.filereadable(new_root_dir .. '/eslint.config.mts') == 1
    or vim.fn.filereadable(new_root_dir .. '/eslint.config.cts') == 1
  then
    config.settings.experimental.useFlatConfig = true
  end

  -- Support Yarn2 (PnP) projects
  local pnp_cjs = util.path.join(new_root_dir, '.pnp.cjs')
  local pnp_js = util.path.join(new_root_dir, '.pnp.js')
  if require("lspconfig.util").path.exists(pnp_cjs) or require("lspconfig.util").path.exists(pnp_js) then
    config.cmd = vim.list_extend({ 'yarn', 'exec' }, config.cmd)
  end
end 

local function eslint_open_doc(_, result)
  if not result then
    return
  end
  local sysname = vim.loop.os_uname().sysname
  if sysname:match 'Windows' then
    os.execute(string.format('start %q', result.url))
  elseif sysname:match 'Linux' then
    os.execute(string.format('xdg-open %q', result.url))
  else
    os.execute(string.format('open %q', result.url))
  end
  return {}
end

local function eslint_confirm_exec(_, result)
  if not result then
    return
  end
  return 4 -- approved
end

local function eslint_probe_failed()
  vim.notify('[lspconfig] ESLint probe failed.', vim.log.levels.WARN)
  return {}
end

local function eslint_no_lib()
  vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
  return {}
end

