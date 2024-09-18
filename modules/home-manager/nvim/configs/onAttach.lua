local function lsp_keymaps(bufnr)
  local buf_opts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "gD", ":Lspsaga lsp_finder<CR>", buf_opts)
  vim.keymap.set("n", "gd", ":Lspsaga goto_definition<CR>", buf_opts)
  vim.keymap.set("n", "gl", ":Lspsaga show_line_diagnostics<CR>", buf_opts)
  vim.keymap.set("n", "gc", ":Lspsaga show_cursor_diagnostics<CR>", buf_opts)
  vim.keymap.set("n", "gp", ":Lspsaga peek_definition<CR>", buf_opts)
  vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", buf_opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts)
end 

local function lsp_highlight(client, bufnr)
  if client.supports_method "textDocument/documentHighlight" then
    vim.api.nvim_create_augroup("lsp_document_highlight", {
      clear = false,
    })
    vim.api.nvim_clear_autocmds {
      buffer = bufnr,
      group = "lsp_document_highlight",
    }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

lsp_keymaps(bufnr)
lsp_highlight(client, bufnr)
if client.supports_method("textDocument/formatting") then
  require("lsp-format").on_attach(client)
end
