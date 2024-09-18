local function fix_zero_version(workspace_edit)
  if workspace_edit and workspace_edit.documentChanges then
    for _, change in pairs(workspace_edit.documentChanges) do
      local text_document = change.textDocument
      if text_document and text_document.version and text_document.version == 0 then
        text_document.version = nil
      end
    end
  end
  return workspace_edit
end

local function java_root_pattern(fname)
  local root_files = {
    -- Multi-module projects
    { '.git', 'build.gradle', 'build.gradle.kts' },
    -- Single-module projects
    {
      'build.xml', -- Ant
      'pom.xml', -- Maven
      'settings.gradle', -- Gradle
      'settings.gradle.kts', -- Gradle
    },
  }
  for _, patterns in ipairs(root_files) do
    local root = require("lspconfig.util").root_pattern(unpack(patterns))(fname)
    if root then
      return root
    end
  end
end

local function java_workspace()
  local cache_dir = os.getenv('XDG_CACHE_HOME') and os.getenv('XDG_CACHE_HOME') or require("lspconfig.util").path.join(vim.loop.os_homedir(), '.cache')
  local jdtls_cache_dir = require("lspconfig.util").path.join(cache_dir, 'jdtls')
  return require("lspconfig.util").path.join(jdtls_cache_dir, 'workspace')
end

local function java_code_action(err, actions, ctx)
  for _, action in ipairs(actions) do
    if action.command == 'java.apply.workspaceEdit' then -- 'action' is Command in java format
      action.edit = fix_zero_version(action.edit or action.arguments[1])
    elseif type(action.command) == 'table' and action.command.command == 'java.apply.workspaceEdit' then -- 'action' is CodeAction in java format
      action.edit = fix_zero_version(action.edit or action.command.arguments[1])
    end
  end
  local handlers = require('vim.lsp.handlers')
  handlers[ctx.method](err, actions, ctx)
end

local function java_rename(err, workspace_edit, ctx)
  local handlers = require('vim.lsp.handlers')
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

local function java_apply_edit(err, workspace_edit, ctx)
  local handlers = require('vim.lsp.handlers')
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

local function java_status()
  local function on_language_status(_, result)
    local command = vim.api.nvim_command
    command 'echohl ModeMsg'
    command(string.format('echo "%s"', result.message))
    command 'echohl None'
  end
  return vim.schedule_wrap(on_language_status)
end
