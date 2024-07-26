local languages = require("efmls-configs.defaults").languages()
-- Filetype 	          Default Linter 	Default Formatter
-- CSS/SCSS/LESS/SASS 	stylelint     	prettier
-- JavaScript/JSX     	eslint 	        prettier
-- TypeScript/TSX     	eslint        	prettier
-- Go                 	golangci_lint
-- HTML 	                            	prettier
-- Lua                	luacheck      	stylua
-- Nix 	                              	alejandra
-- PHP                 	phpcs         	phpcbf
-- Python             	flake8        	autopep8
-- Ruby                	reek
-- VIM 	                vint
-- Blade 		                            blade_formatter

languages = vim.tbl_extend("force", languages, {
  -- Custom languages, or override existing ones
  misc = {
    require("efmls-configs.linters.alex"),
    require("efmls-configs.linters.codespell"),
    require("efmls-configs.linters.vale"),
  },
  bash = {
    require("efmls-configs.linters.shellcheck"),
    require("efmls-configs.formatters.shfmt"),
    require("efmls-configs.formatters.beautysh"),
  },
  ["C#"] = {
    require("efmls-configs.linters.mcs"),
    require("efmls-configs.formatters.uncrustify"),
  },
  ["C++"] = {
    require("efmls-configs.linters.clang_tidy"),
    require("efmls-configs.linters.cpplint"),
    require("efmls-configs.formatters.clang_tidy"),
    require("efmls-configs.formatters.uncrustify"),
    require("efmls-configs.formatters.clang_format"),
  },
  c = {
    require("efmls-configs.linters.clang_tidy"),
    require("efmls-configs.linters.cpplint"),
    require("efmls-configs.formatters.clang_tidy"),
    require("efmls-configs.formatters.uncrustify"),
    require("efmls-configs.formatters.clang_format"),
  },
  cmake = {
    require("efmls-configs.linters.cmake_lint"),
    require("efmls-configs.formatters.gersemi"),
  },
  csh = {
    require("efmls-configs.formatters.beautysh"),
  },
  css = {
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.linters.stylelint"),
    require("efmls-configs.formatters.stylelint"),
  },
  scss = {
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.linters.stylelint"),
    require("efmls-configs.formatters.stylelint"),
  },
  less = {
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.linters.stylelint"),
    require("efmls-configs.formatters.stylelint"),
  },
  sass = {
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.linters.stylelint"),
    require("efmls-configs.formatters.stylelint"),
  },
  html = {
    require("efmls-configs.linters.djlint"),
    require("efmls-configs.formatters.prettier_d"),
  },
  javascript = {
    require("efmls-configs.linters.eslint_d"),
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.formatters.eslint_d"),
    require("efmls-configs.formatters.prettier_eslint"),
  },
  javascriptreact = {
    require("efmls-configs.linters.eslint_d"),
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.formatters.eslint_d"),
    require("efmls-configs.formatters.prettier_eslint"),
  },
  typescript = {
    require("efmls-configs.linters.eslint_d"),
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.formatters.eslint_d"),
    require("efmls-configs.formatters.prettier_eslint"),
  },
  typescriptreact = {
    require("efmls-configs.linters.eslint_d"),
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.formatters.eslint_d"),
    require("efmls-configs.formatters.prettier_eslint"),
  },
  graphql = {
    require("efmls-configs.formatters.prettier_d"),
  },
  json = {
    require("efmls-configs.linters.jq"),
    require("efmls-configs.formatters.prettier_d"),
  },
  markdown = {
    require("efmls-configs.linters.markdownlint"),
    require("efmls-configs.formatters.mdformat"),
    require("efmls-configs.formatters.cbfmt"),
  },
  svelte = {
    require("efmls-configs.linters.eslint_d"),
    require("efmls-configs.formatters.prettier_d"),
    require("efmls-configs.formatters.eslint_d"),
    require("efmls-configs.formatters.prettier_eslint"),
  },
  yaml = {
    require("efmls-configs.linters.actionlint"),
    require("efmls-configs.linters.yamllint"),
    require("efmls-configs.formatters.prettier"),
  },
  docker = {
    require("efmls-configs.linters.hadolint"),
  },
  fish = {
    require("efmls-configs.linters.fish"),
    require("efmls-configs.formatters.fish_indent"),
  },
  gitcommit = {
    require("efmls-configs.linters.gitlint"),
  },
  go = {
    require("efmls-configs.linters.golangci_lint"),
    require("efmls-configs.formatters.gofmt"),
  },
  java = {
    require("efmls-configs.formatters.google_java_format"),
    require("efmls-configs.linters.uncrustify"),
  },
  ksh = {
    require("efmls-configs.formatters.beautysh"),
  },
  make = {
    require("efmls-configs.linters.checkmake"),
  },
  nix = {
    require("efmls-configs.linters.statix"),
    require("efmls-configs.formatters.alejandra"),
  },
  ["objective-c++"] = {
    require("efmls-configs.formatters.uncrustify"),
  },
  ["objective-c"] = {
    require("efmls-configs.formatters.uncrustify"),
  },
  pawn = {
    require("efmls-configs.formatters.uncrustify"),
  },
  proto = {
    require("efmls-configs.formatters.protolint"),
  },
  python = {
    require("efmls-configs.linters.djlint"),
    require("efmls-configs.linters.vulture"),
    require("efmls-configs.formatters.isort"),
    require("efmls-configs.formatters.ruff"),
  },
  rust = {
    require("efmls-configs.formatters.rustfmt"),
  },
  sh = {
    require("efmls-configs.linters.shellcheck"),
    require("efmls-configs.formatters.beautysh"),
    require("efmls-configs.formatters.shfmt"),
  },
  terraform = {
    require("efmls-configs.formatters.terraform_fmt"),
  },
  toml = {
    require("efmls-configs.formatters.dprint"),
  },
  zsh = {
    require("efmls-configs.formatters.beautysh"),
  },
})

local efmls_config = {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git/" },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}

return efmls_config
