if vim.g.vscode then
  require "core.options"
else
  local name = "nightly"

  require "core"
  require "plugin-loader"

  -- Check for theme configuration
  -- Theme configs are can be found on lua/plugins/theme
  pcall(require, "plugins.theme." .. name)

  vim.cmd [[
    set spell
    syntax enable
    filetype plugin indent on
    set modeline
    set modelines=5
  ]]

  function VimtexPDFToggle()
    if vim.g.term_pdf_vierer_open then
      vim.notify("Closing the PDF viewer", vim.log.levels.INFO, { title = "TeX" })
      vim.system({ "kitty", "@", "close-window", "--match", "title:termpdf" })
      vim.g.term_pdf_vierer_open = false
    elseif vim.g.tex_compiles_successfully then
      vim.system({ "kitty", "@", "launch", "--location=vsplit", "--cwd=current", "--title=termpdf" })
      vim.notify("Opening the PDF viewer", vim.log.levels.INFO, { title = "TeX" })
      local kitty = { "kitty", "@", "send-text", "--match", "title:termpdf", vim.g.python3_host_prog, "-m", "termpdf",
        vim.api.nvim_call_function("expand", { "%:r" }) .. ".pdf", '\r' }
      os.execute("sleep 0.5")
      vim.system(kitty)
      vim.g.term_pdf_vierer_open = true
    end
  end

  -- Set the theme
  vim.cmd.colorscheme(name)
end
