{
  pkgs,
  lib,
  ...
}: let
  ansiblePython = pkgs.unstable.python312.withPackages (p: [
    p.ansible-core
    p.ansible
    p.jinja2-ansible-filters
    p.ansible-builder
    p.pytest-ansible
    p.ansible-compat
  ]);

  util = ''require("lspconfig.util")'';

  signs = ''
    local signs = {
      Error = "",
      Warn = "",
      Hint = "󰌵",
      Info = ""
    }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  '';

  config = ''
    ${signs}
    local config = {
      -- Enable virtual text
      virtual_text = true,
      -- Show signs
      signs = {
        active = signs,
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }
    vim.diagnostic.config(config)
  '';

  onHover = ''
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })
  '';

  onDiagnose = ''
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = {
        spacing = 5,
        severity_limit = "Warning",
      },
      update_in_insert = true,
    })
  '';

  onSignatureHelp = ''
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })
  '';

  onAttach = builtins.readFile ../configs/onAttach.lua;

  rls = pkgs.rWrapper.override {packages = with pkgs.rPackages; [languageserver];};
in {
  programs.nixvim.plugins.lsp = {
    enable = true;
    package = pkgs.unstable.vimPlugins.nvim-lspconfig;
    inlayHints = true;

    capabilities = ''require("cmp_nvim_lsp").default_capabilities()'';

    onAttach = "${onAttach}";

    preConfig = ''
      ${config}
      ${onHover}
      ${onDiagnose}
      ${onSignatureHelp}
    '';

    servers = {
      ansiblels = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.ansible-language-server;
        cmd = [
          "${pkgs.unstable.ansible-language-server}/bin/ansible-language-server"
          "--stdio"
        ];
        filetypes = ["yaml.ansible"];
        extraOptions = {
          ansible = {
            ansible = {
              path = "${ansiblePython}/bin/ansible";
            };
            executionEnvironment = {
              enabled = true;
            };
            python = {
              interpreterPath = "${ansiblePython}/bin/python312";
            };
            validation = {
              enabled = true;
              lint = {
                enabled = true;
                path = "${pkgs.unstable.ansible-lint}/bin/ansible-lint";
              };
            };
          };
        };
      };

      astro = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.astro-language-server;
        cmd = [
          "${pkgs.unstable.astro-language-server}/bin/astro-ls"
          "--stdio"
        ];
        filetypes = ["astro"];
        extraOptions = {
          typescript = {};
        };
        rootDir.__raw = ''${util}.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')'';
      };

      bashls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.bash-language-server;
        cmd = ["${pkgs.unstable.bash-language-server}/bin/bash-language-server" "start"];
        filetypes = ["sh"];
        extraOptions = {
          bashIde = {
            globPattern.__raw = ''vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)"'';
          };
        };
        rootDir.__raw = ''${util}.find_git_ancestor'';
      };

      biome = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.biome;
        cmd = [
          "${pkgs.unstable.biome}/bin/biome"
          "lsp-proxy"
        ];
        filetypes = [
          "javascript"
          "javascriptreact"
          "json"
          "jsonc"
          "typescript"
          "typescript.tsx"
          "typescriptreact"
          "astro"
          "svelte"
          "vue"
          "css"
        ];
        rootDir.__raw = ''${util}.root_pattern('biome.json', 'biome.jsonc')'';
      };

      bufls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.buf-language-server;
        cmd = [
          "${pkgs.unstable.buf-language-server}/bin/bufls"
          "serve"
        ];
        filetypes = ["proto"];
        rootDir.__raw = ''function(fname) return ${util}.root_pattern('buf.work.yaml', '.git')(fname) end'';
      };

      clangd = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.rocmPackages.llvm.clang-tools-extra;
        rootDir.__raw = ''function(fname) return ${util}.root_pattern('.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac')(fname) or ${util}.find_git_ancestor(fname) end'';
        cmd = ["${pkgs.unstable.rocmPackages.llvm.clang-tools-extra}/bin/clangd"];
        filetypes = ["c" "cpp" "objc" "objcpp" "cuda" "proto"];
        extraOptions = {
          capabilities = {
            textDocument = {
              completion = {
                editsNearCursor = true;
              };
            };
            offsetEncoding = ["utf-8" "utf-16"];
          };
        };
      };

      cmake = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.cmake-language-server;
        cmd = ["${pkgs.unstable.cmake-language-server}/bin/cmake-language-server"];
        filetypes = ["cmake"];
        rootDir.__raw = ''function(fname) return ${util}.root_pattern(unpack('CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake'))(fname) end'';
        extraOptions = {
          init_options = {
            buildDirectory = "build";
          };
        };
      };

      cssls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.vscode-langservers-extracted;
        cmd = ["${pkgs.unstable.vscode-langservers-extracted}/bin/vscode-css-language-server" "--stdio"];
        filetypes = ["css" "scss" "less"];
        extraOptions = {
          init_options.provideFormatter = true;
        };
        rootDir.__raw = ''${util}.root_pattern('package.json', '.git')'';
        settings = {
          css.validate = true;
          scss.validate = true;
          less.validate = true;
        };
      };

      docker-compose-language-service = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.docker-compose-language-service;
        cmd = ["${pkgs.unstable.docker-compose-language-service}/bin/docker-compose-langserver" "--stdio"];
        filetypes = ["yaml.docker-compose"];
        rootDir.__raw = ''${util}.root_pattern('docker-compose.yaml', 'docker-compose.yml', 'compose.yaml', 'compose.yml')'';
      };

      dockerls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.dockerfile-language-server-nodejs;
        cmd = ["${pkgs.unstable.dockerfile-language-server-nodejs}/bin/docker-langserver" "--stdio"];
        filetypes = ["dockerfile"];
        rootDir.__raw = ''${util}.root_pattern('Dockerfile')'';
      };

      efm = {
        enable = true;
        autostart = true;
        filetypes = ["*"];
        package = pkgs.unstable.efm-langserver;
        cmd = ["${pkgs.unstable.efm-langserver}/bin/efm-langserver"];
        rootDir.__raw = ''${util}.find_git_ancestor'';
      };

      emmet-ls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.emmet-ls;
        cmd = ["${pkgs.unstable.emmet-ls}/bin/emmet-ls" "--stdio"];
        filetypes = [
          "astro"
          "css"
          "eruby"
          "html"
          "htmldjango"
          "javascriptreact"
          "less"
          "pug"
          "sass"
          "scss"
          "svelte"
          "typescriptreact"
          "vue"
          "htmlangular"
        ];
        rootDir.__raw = ''${util}.find_git_ancestor'';
      };

      eslint = {
        package = pkgs.unstable.vscode-langservers-extracted;
        cmd = [
          "${pkgs.unstable.vscode-langservers-extracted}/bin/vscode-eslint-language-server"
          "--stdio"
        ];
        filetypes = [
          "javascript"
          "javascriptreact"
          "javascript.jsx"
          "typescript"
          "typescriptreact"
          "typescript.tsx"
          "vue"
          "svelte"
          "astro"
        ];
        rootDir.__raw = ''eslint_root_dir'';
        settings = {
          validate = "on";
          useESLintClass = false;
          experimental.useFlatConfig = false;
          codeActionOnSave = {
            enable = true;
            mode = "all";
          };
          format = true;
          quiet = false;
          onIgnoredFiles = "off";
          run = "onType";
          problems.shortenToSingleLine = false;
          nodePath = "";
          workingDirectory.mode = "location";
          codeAction = {
            disableRuleComment = {
              enable = true;
              location = "separateLine";
            };
            showDocumentation.enable = true;
          };
        };
        extraOptions = {
          on_new_config.__raw = ''on_new_config'';
          handlers = {
            "eslint/openDoc".__raw = ''eslint_open_doc'';
            "eslint/confirmESLintExecution".__raw = ''eslint_confirm_exec'';
            "eslint/probeFailed".__raw = ''eslint_probe_failed'';
            "eslint/noLibrary".__raw = ''eslint_no_lib'';
          };
        };
      };

      gleam = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.gleam;
        cmd = ["${pkgs.unstable.gleam}/bin/gleam" "lsp"];
        filetypes = ["gleam"];
        rootDir.__raw = ''function(fname) return ${util}.root_pattern('gleam.toml', '.git')(fname) end'';
      };

      golangci-lint-ls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.golangci-lint-langserver;
        cmd = ["${pkgs.unstable.golangci-lint-langserver}/bin/golangci-lint-langserver"];
        filetypes = ["go" "gomod"];
        extraOptions = {
          init_options = {
            command = ["golangci-lint" "run" "--out-format" "json"];
          };
        };
        rootDir.__raw = ''go_root_pattern'';
      };

      gopls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.gopls;
        cmd = ["${pkgs.unstable.gopls}/bin/gopls"];
        filetypes = ["go" "gomod" "gowork" "gotmpl"];
        rootDir.__raw = ''gopls_root_pattern'';
      };

      graphql = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nodePackages.graphql-language-service-cli;
        cmd = ["${pkgs.unstable.nodePackages.graphql-language-service-cli}/bin/graphql-lsp" "server" "-m" "stream"];
        filetypes = ["graphql" "typescriptreact" "javascriptreact"];
        rootDir.__raw = ''${util}.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*')'';
      };

      harper-ls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.harper;
        cmd = ["${pkgs.unstable.harper}/bin/harper-ls" "--stdio"];
        filetypes = [
          "markdown"
          "rust"
          "typescript"
          "typescriptreact"
          "javascript"
          "python"
          "go"
          "c"
          "cpp"
          "ruby"
          "swift"
          "csharp"
          "toml"
          "lua"
          "gitcommit"
          "java"
          "html"
        ];
        rootDir.__raw = ''${util}.find_git_ancestor'';
      };

      helm-ls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.helm-ls;
        cmd = ["${pkgs.unstable.helm-ls}/bin/helm_ls" "serve"];
        filetypes = ["helm"];
        rootDir.__raw = ''${util}.root_pattern('Chart.yaml')'';
        extraOptions.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true;
      };

      html = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.vscode-langservers-extracted;
        cmd = ["${pkgs.unstable.vscode-langservers-extracted}/bin/vscode-html-language-server" "--stdio"];
        filetypes = ["html" "templ"];
        rootDir.__raw = ''${util}.root_pattern("package.json", ".git")'';
        extraOptions.init_options = {
          provideFormatter = true;
          embeddedLanguages = {
            css = true;
            javascript = true;
          };
          configurationSection = ["html" "css" "javascript"];
        };
      };

      htmx = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.htmx-lsp;
        cmd = ["${pkgs.unstable.htmx-lsp}/bin/htmx-lsp"];
        filetypes = [
          "aspnetcorerazor"
          "astro"
          "astro-markdown"
          "blade"
          "clojure"
          "django-html"
          "htmldjango"
          "edge"
          "eelixir"
          "elixir"
          "ejs"
          "erb"
          "eruby"
          "gohtml"
          "gohtmltmpl"
          "haml"
          "handlebars"
          "hbs"
          "html"
          "htmlangular"
          "html-eex"
          "heex"
          "jade"
          "leaf"
          "liquid"
          "markdown"
          "mdx"
          "mustache"
          "njk"
          "nunjucks"
          "php"
          "razor"
          "slim"
          "twig"
          "javascript"
          "javascriptreact"
          "reason"
          "rescript"
          "typescript"
          "typescriptreact"
          "vue"
          "svelte"
          "templ"
        ];
        rootDir.__raw = ''function(fname) return ${util}.find_git_ancestor(fname) end'';
      };

      intelephense = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nodePackages_latest.intelephense;
        cmd = ["${pkgs.unstable.nodePackages_latest.intelephense}/bin/intelephense" "--stdio"];
        filetypes = ["php"];
        rootDir.__raw = ''php_root_pattern'';
      };

      java-language-server = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.java-language-server;
        cmd = ["${pkgs.unstable.java-language-server}/bin/java-language-server"];
        filetypes = ["java"];
        rootDir.__raw = ''${util}.root_pattern('build.gradle', 'pom.xml', '.git')'';
      };

      jdt-language-server = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.jdt-language-server;
        cmd = [
          "${pkgs.unstable.jdt-language-server}/bin/jdtls"
        ];
        filetypes = ["java"];
        rootDir.__raw = ''java_root_pattern'';
        extraOptions = {
          init_options = {
            workspace.__raw = ''java_workspace'';
          };
          handlers = {
            "textDocument/codeAction".__raw = ''java_code_action'';
            "textDocument/rename".__raw = ''java_rename'';
            "workspace/applyEdit".__raw = ''java_apply_edit'';
            "language/status".__raw = ''java_status'';
          };
        };
      };

      jsonls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.vscode-langservers-extracted;
        cmd = ["${pkgs.unstable.vscode-langservers-extracted}/bin/vscode-json-language-server" "--stdio"];
        filetypes = ["json" "jsonc"];
        extraOptions = {
          init_options.provideFormatter = true;
          settings.json.schemas.__raw = lib.mkForce ''require('schemastore').json.schemas()'';
        };
        rootDir.__raw = ''${util}.find_git_ancestor'';
      };

      lemminx = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.lemminx;
        cmd = ["${pkgs.unstable.lemminx}/bin/lemminx"];
        filetypes = ["xml" "xsd" "xsl" "xslt" "svg"];
        rootDir.__raw = ''${util}.find_git_ancestor'';
      };

      lexical = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.lexical;
        cmd = ["${pkgs.unstable.lexical}/bin/lexical"];
        filetypes = ["elixir" "eelixir" "heex" "surface"];
        rootDir.__raw = ''function(fname) return ${util}.root_pattern('mix.exs')(fname) or ${util}.find_git_ancestor(fname) end'';
      };

      ltex = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.ltex-ls;
        cmd = ["${pkgs.unstable.ltex-ls}/bin/ltex-ls"];

        filetypes = [
          "bib"
          "gitcommit"
          "markdown"
          "org"
          "plaintex"
          "rst"
          "rnoweb"
          "tex"
          "pandoc"
          "quarto"
          "rmd"
          "context"
          "html"
          "xhtml"
          "mail"
          "text"
        ];

        rootDir.__raw = ''${util}.find_git_ancestor'';
        extraOptions.get_language_id.__raw = ''ltex_get_language'';

        settings = {
          completionEnabled = true;
          enabled = [
            "bibtex"
            "gitcommit"
            "markdown"
            "org"
            "restructuredtext"
            "rsweave"
            "tex"
            "latex"
            "markdown"
            "quarto"
            "rmd"
            "context"
            "html"
            "xhtml"
            "mail"
            "plaintext"
          ];
        };
      };

      lua-ls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.lua-language-server;
        cmd = ["${pkgs.unstable.lua-language-server}/bin/lua-language-server"];
        filetypes = ["lua"];
        rootDir.__raw = ''lua_root_dir'';
      };

      marksman = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.marksman;
        cmd = ["${pkgs.unstable.marksman}/bin/marksman" "server"];
        filetypes = ["markdown" "markdown.mdx"];
        rootDir.__raw = ''md_root_dir'';
      };

      nginx-language-server = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nginx-language-server;
        cmd = ["${pkgs.unstable.nginx-language-server}/bin/nginx-language-server"];
        filetypes = ["nginx"];
        rootDir.__raw = ''function(fname) return ${util}.root_pattern('nginx.conf', '.git')(fname) or ${util}.find_git_ancestor(fname) end'';
      };

      perlpls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.perl538Packages.PLS;
        cmd = ["${pkgs.unstable.perl538Packages.PLS}/bin/pls"];
        settings = {
          perl = {
            perlcritic.enabled = false;
            syntax.enabled = true;
          };
        };
        filetypes = ["perl"];
        rootDir.__raw = ''${util}.find_git_ancestor'';
      };

      phpactor = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.phpactor;
        cmd = ["${pkgs.unstable.phpactor}/bin/phpactor" "language-server"];
        filetypes = ["php"];
        rootDir.__raw = ''php_actor_root_dir'';
      };

      prismals = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nodePackages."@prisma/language-server";
        cmd = ["${pkgs.unstable.nodePackages."@prisma/language-server"}/bin/prisma-language-server" "--stdio"];
        filetypes = ["prisma"];
        settings.prisma.prismaFmtBinPath = "";
        rootDir.__raw = ''${util}.root_pattern('.git', 'package.json')'';
      };

      r-language-server = {
        enable = true;
        autostart = true;
        package = rls;
        cmd = ["${rls}/bin/R" "--no-echo" "-e" "languageserver::run()"];
        filetypes = ["r" "rmd"];
        rootDir.__raw = ''function(fname) return ${util}.find_git_ancestor(fname) or vim.loop.os_homedir() end'';
      };

      ruby-lsp = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.ruby-lsp;
        cmd = ["${pkgs.unstable.ruby-lsp}/bin/ruby-lsp"];
        filetypes = ["ruby"];
        rootDir.__raw = ''${util}.root_pattern('Gemfile', '.git')'';
        extraOptions.init_options.formatter = "auto";
      };

      ruff = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.ruff;
        cmd = ["${pkgs.unstable.ruff}/bin/ruff" "server"];
        filetypes = ["python"];
        rootDir.__raw = ''${util}.root_pattern('pyproject.toml', 'ruff.toml', '.ruff.toml') or ${util}.find_git_ancestor()'';
      };

      rust-analyzer = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.rust-analyzer;
        cmd = ["${pkgs.unstable.rust-analyzer}/bin/rust-analyzer"];
        installRustc = true;
        installCargo = true;
        filetypes = ["rust"];
        rootDir.__raw = ''rust_root_dir'';
        extraOptions = {
          capabilities.experimental.serverStatusNotification = true;
          before_init.__raw = ''rust_before_init'';
        };
      };

      svelte = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nodePackages_latest.svelte-language-server;
        cmd = ["${pkgs.unstable.nodePackages_latest.svelte-language-server}/bin/svelteserver" "--stdio"];
        filetypes = ["svelte"];
        rootDir.__raw = ''${util}.root_pattern('package.json', '.git')'';
      };

      tailwindcss = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nodePackages."@tailwindcss/language-server";
        cmd = ["${pkgs.unstable.nodePackages."@tailwindcss/language-server"}/bin/tailwindcss-language-server" "--stdio"];
        filetypes = [
          "aspnetcorerazor"
          "astro"
          "astro-markdown"
          "blade"
          "clojure"
          "django-html"
          "htmldjango"
          "edge"
          "eelixir"
          "elixir"
          "ejs"
          "erb"
          "eruby"
          "gohtml"
          "gohtmltmpl"
          "haml"
          "handlebars"
          "hbs"
          "html"
          "htmlangular"
          "html-eex"
          "heex"
          "jade"
          "leaf"
          "liquid"
          "markdown"
          "mdx"
          "mustache"
          "njk"
          "nunjucks"
          "php"
          "razor"
          "slim"
          "twig"
          "css"
          "less"
          "postcss"
          "sass"
          "scss"
          "stylus"
          "sugarss"
          "javascript"
          "javascriptreact"
          "reason"
          "rescript"
          "typescript"
          "typescriptreact"
          "vue"
          "svelte"
          "templ"
        ];
        settings = {
          tailwindCSS = {
            validate = true;
            lint = {
              cssConflict = "warning";
              invalidApply = "error";
              invalidScreen = "error";
              invalidVariant = "error";
              invalidConfigPath = "error";
              invalidTailwindDirective = "error";
              recommendedVariantOrder = "warning";
            };
            classAttributes = [
              "class"
              "className"
              "class:list"
              "classList"
              "ngClass"
            ];
            includeLanguages = {
              eelixir = "html-eex";
              eruby = "erb";
              templ = "html";
              htmlangular = "html";
            };
          };
        };
        extraOptions = {
          on_new_config.__raw = ''tailwind_on_new_config'';
        };
        rootDir.__raw = ''tailwind_root_dir'';
      };

      taplo = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.taplo;
        cmd = ["${pkgs.unstable.taplo}/bin/taplo" "lsp" "stdio"];
        filetypes = ["toml"];
        rootDir.__raw = ''${util}.find_git_ancestor'';
      };

      terraformls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.terraform-ls;
        cmd = ["${pkgs.unstable.terraform-ls}/bin/terraform-ls" "serve"];
        filetypes = ["terraform" "terraform-vars"];
        rootDir.__raw = ''${util}.root_pattern('.terraform', '.git')'';
      };

      texlab = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.texlab;
        cmd = ["${pkgs.unstable.texlab}/bin/texlab"];
        filetypes = ["tex" "plaintex" "bib"];
        rootDir.__raw = ''${util}.root_pattern('.git', '.latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml')'';
        settings = {
          texlab = {
            build = {
              executable = "${pkgs.unstable.texliveFull}/bin/latexmk";
              args = ["-pdf" "-interaction=nonstopmode" "-synctex=1" "%f"];
              onSave = false;
              forwardSearchAfter = false;
            };
            auxDirectory = ".";
            chktex = {
              onOpenAndSave = false;
              onEdit = false;
            };
            diagnosticsDelay = 300;
            latexFormatter = "${pkgs.unstable.texliveFull}/bin/latexindent";
            latexindent = {
              modifyLineBreaks = false;
            };
            bibtexFormatter = "${pkgs.unstable.texlab}/bin/texlab";
            formatterLineLength = 80;
          };
        };
      };

      tflint = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.tflint;
        cmd = ["${pkgs.unstable.tflint}/bin/tflint" "--langserver"];
        filetypes = ["terraform"];
        rootDir.__raw = ''${util}.root_pattern('.terraform', '.git', '.tflint.hcl')'';
      };

      ts-ls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.typescript-language-server;
        extraOptions = {
          init_options = {
            hostInfo = "neovim";
          };
        };
        cmd = ["${pkgs.unstable.typescript-language-server}/bin/typescript-language-server" "--stdio"];
        filetypes = [
          "javascript"
          "javascriptreact"
          "javascript.jsx"
          "typescript"
          "typescriptreact"
          "typescript.tsx"
        ];
        rootDir.__raw = ''${util}.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')'';
      };

      vuels = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nodePackages.vls;
        cmd = ["${pkgs.unstable.nodePackages.vls}/bin/vls"];
        filetypes = ["vue"];
        rootDir.__raw = ''${util}.root_pattern('package.json', 'vue.config.js')'';
        extraOptions = {
          init_options = {
            config = {
              vetur = {
                useWorkspaceDependencies = false;
                validation = {
                  template = true;
                  style = true;
                  script = true;
                };
                completion = {
                  autoImport = false;
                  useScaffoldSnippets = false;
                  tagCasing = "kebab";
                };
                format = {
                  defaultFormatter = {
                    js = "none";
                    ts = "none";
                  };
                  defaultFormatterOptions = {};
                  scriptInitialIndent = false;
                  styleInitialIndent = false;
                };
              };
              css = {};
              html = {
                suggest = {};
              };
              javascript = {
                format = {};
              };
              typescript = {
                format = {};
              };
              emmet = {};
              stylusSupremacy = {};
            };
          };
        };
      };

      yamlls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.yaml-language-server;
        cmd = ["${pkgs.unstable.yaml-language-server}/bin/yaml-language-server" "--stdio"];
        filetypes = ["yaml" "yaml.docker-compose" "yaml.gitlab"];
        rootDir.__raw = ''${util}.find_git_ancestor'';
        extraOptions = {
          settings = {
            redhat.telemetry.enabled = false;
            schemaStore.enable = true;
            schemas.__raw = lib.mkForce ''require('schemastore').yaml.schemas()'';
          };
        };
      };
    };
  };
}
