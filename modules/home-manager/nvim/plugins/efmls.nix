{
  programs.nixvim.plugins.efmls-configs = {
    enable = true;
    externallyManagedPackages = [
      "cspell"
      "gersemi"
      "pint"
    ];
    setup = {
      all.linter = [
        "alex"
        "cspell"
        "languagetool"
      ];
      bash = {
        formatter = "beautysh";
        linter = "shellcheck";
      };
      c = {
        formatter = [
          "clang_format"
          "uncrustify"
        ];
        linter = [
          "cppcheck"
          "clang_tidy"
          "cpplint"
        ];
      };
      "c++" = {
        formatter = [
          "clang_format"
          "uncrustify"
        ];
        linter = [
          "cppcheck"
          "clang_tidy"
          "cpplint"
        ];
      };
      cmake = {
        formatter = "gersemi";
        linter = "cmake_lint";
      };
      csh.formatter = "beautysh";
      css = {
        formatter = [
          "prettier_d"
          "stylelint"
        ];
        linter = "stylelint";
      };
      docker.linter = "hadolint";
      fish = {
        formatter = "fish_indent";
        linter = "fish";
      };
      gitcommit.linter = "gitlint";
      go = {
        formatter = [
          "gofmt"
          "gofumpt"
          "goimports"
          "golines"
        ];
        linter = [
          "djlint"
          "golangci_lint"
        ];
      };
      haskell.formatter = "fourmolu";
      html = {
        formatter = "prettier_d";
        linter = "djlint";
      };
      java.formatter = "google_java_format";
      javascript = {
        formatter = [
          "eslint_d"
          "prettier_d"
          "biome"
        ];
        linter = "eslint_d";
      };
      json = {
        formatter = [
          "biome"
          "jq"
          "prettier_d"
        ];
        linter = "jq";
      };
      less = {
        formatter = [
          "prettier_d"
          "stylelint"
        ];
        linter = "stylelint";
      };
      lua = {
        formatter = [
          "lua_format"
          "stylua"
        ];
        linter = "luacheck";
      };
      make.linter = "checkmake";
      markdown = {
        formatter = "mdformat";
        linter = "markdownlint";
      };
      nix = {
        formatter = "alejandra";
        linter = "statix";
      };
      php = {
        formatter = [
          "phpcbf"
          "pint"
        ];
        linter = [
          "phpstan"
          "psalm"
        ];
      };
      python = {
        formatter = [
          "black"
          "isort"
          "ruff"
        ];
        linter = [
          "flake8"
          "ruff"
        ];
      };
      ruby.linter = "rubocop";
      rust.formatter = "rustfmt";
      sass = {
        formatter = [
          "prettier_d"
          "stylelint"
        ];
        linter = "stylelint";
      };
      scss = {
        formatter = [
          "prettier_d"
          "stylelint"
        ];
        linter = "stylelint";
      };
      sh = {
        formatter = "beautysh";
        linter = "shellcheck";
      };
      sql = {
        formatter = "sql-formatter";
        linter = "sqlfluff";
      };
      terraform.formatter = "terraform_fmt";
      tex = {
        formatter = "latexindent";
        linter = "chktex";
      };
      toml.formatter = "taplo";
      typescript = {
        formatter = [
          "biome"
          "eslint_d"
          "prettier_d"
        ];
        linter = [
          "eslint_d"
        ];
      };
      vim.linter = "vint";
      yaml = {
        formatter = [
          "prettier"
        ];
        linter = [
          "yamllint"
          "actionlint"
          "ansible_lint"
        ];
      };
      zsh.formatter = "beautysh";
    };
  };
}
