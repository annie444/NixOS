{pkgs, ...}: let
  ansiblePython = pkgs.unstable.python312.withPackages (p: [
    p.ansible-core
    p.ansible
    p.jinja2-ansible-filters
    p.ansible-builder
    p.pytest-ansible
    p.ansible-compat
  ]);

  util = ''require("lspconfig.util")'';
  async = ''require('lspconfig.async')'';

  rust = {
    isLibrary = ''
      local function is_library(fname)
        local user_home = ${util}.path.sanitize(vim.env.HOME)
        local cargo_home = os.getenv 'CARGO_HOME' or ${util}.path.join(user_home, '.cargo')
        local registry = ${util}.path.join(cargo_home, 'registry', 'src')
        local git_registry = ${util}.path.join(cargo_home, 'git', 'checkouts')

        local rustup_home = os.getenv 'RUSTUP_HOME' or ${util}.path.join(user_home, '.rustup')
        local toolchains = ${util}.path.join(rustup_home, 'toolchains')

        for _, item in ipairs { toolchains, registry, git_registry } do
          if ${util}.path.is_descendant(item, fname) then
            local clients = ${util}.get_lsp_clients { name = 'rust_analyzer' }
            return #clients > 0 and clients[#clients].config.root_dir or nil
          end
        end
      end
    '';

    reloadWorkspace = ''
      local function reload_workspace(bufnr)
        bufnr = ${util}.validate_bufnr(bufnr)
        local clients = ${util}.get_lsp_clients { bufnr = bufnr, name = 'rust_analyzer' }
        for _, client in ipairs(clients) do
          vim.notify 'Reloading Cargo Workspace'
          client.request('rust-analyzer/reloadWorkspace', nil, function(err)
            if err then
              error(tostring(err))
            end
            vim.notify 'Cargo workspace reloaded'
          end, 0)
        end
      end
    '';
  };

  lspKeymaps = ''
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
  '';

  lspHighlight = ''
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
  '';

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

  fixZeroVersion = ''
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
  '';

  rls = pkgs.rWrapper.override {packages = with pkgs.rPackages; [languageserver];};
in {
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    capabilities = ''
      require("cmp_nvim_lsp").default_capabilities()
    '';
    onAttach = ''
      function(client, bufnr)
        ${lspKeymaps}
        ${lspHighlight}
        lsp_keymaps(bufnr)
        lsp_highlight(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          require("lsp-format").on_attach(client)
        end
      end
    '';
    preConfig = ''
      function()
        ${config}
        ${onHover}
        ${onDiagnose}
        ${onSignatureHelp}
      end
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
              path = "${pkgs.unstable.ansible}/bin/ansible";
            };
            executionEnvironment = {
              enabled = false;
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
        rootDir.__raw = ''
          function(fname)
            return ${util}.root_pattern('buf.work.yaml', '.git')(fname)
          end
        '';
      };

      clangd = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.rocmPackages.llvm.clang-tools-extra;
        rootDir.__raw = ''
          function(fname)
            return ${util}.root_pattern('.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac')(fname) or ${util}.find_git_ancestor(fname)
          end
        '';
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
        rootDir.__raw = ''
          function(fname)
            return util.root_pattern(unpack('CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake'))(fname)
          end
        '';
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
        rootDir.__raw = ''
          function(fname)
            root_file = ${util}.insert_package_json(root_file, 'eslintConfig', fname)
            return ${util}.root_pattern(unpack(root_file))(fname)
          end
        '';
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
          on_new_config.__raw = ''
            function(config, new_root_dir)
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
              if ${util}.path.exists(pnp_cjs) or ${util}.path.exists(pnp_js) then
                config.cmd = vim.list_extend({ 'yarn', 'exec' }, config.cmd)
              end
            end
          '';
          handlers = {
            "eslint/openDoc".__raw = ''
              function(_, result)
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
            '';
            "eslint/confirmESLintExecution".__raw = ''
              function(_, result)
                if not result then
                  return
                end
                return 4 -- approved
              end
            '';
            "eslint/probeFailed".__raw = ''
              function()
                vim.notify('[lspconfig] ESLint probe failed.', vim.log.levels.WARN)
                return {}
              end
            '';
            "eslint/noLibrary".__raw = ''
              function()
                vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
                return {}
              end
            '';
          };
        };
      };

      gleam = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.gleam;
        cmd = ["${pkgs.unstable.gleam}/bin/gleam" "lsp"];
        filetypes = ["gleam"];
        rootDir.__raw = ''
          function(fname)
            return ${util}.root_pattern('gleam.toml', '.git')(fname)
          end
        '';
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
        rootDir.__raw = ''
          function(fname)
            return ${util}.root_pattern(
              '.golangci.yml',
              '.golangci.yaml',
              '.golangci.toml',
              '.golangci.json',
              'go.work',
              'go.mod',
              '.git'
            )(fname)
          end
        '';
      };

      gopls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.gopls;
        cmd = ["${pkgs.unstable.gopls}/bin/gopls"];
        filetypes = ["go" "gomod" "gowork" "gotmpl"];
        rootDir.__raw = ''
          function(fname)
            -- see: https://github.com/neovim/nvim-lspconfig/issues/804
            if not mod_cache then
              local result = require("lspconfig.async").run_command { 'go', 'env', 'GOMODCACHE' }
              if result and result[1] then
                mod_cache = vim.trim(result[1])
              end
            end
            if fname:sub(1, #mod_cache) == mod_cache then
              local clients = ${util}.get_lsp_clients { name = 'gopls' }
              if #clients > 0 then
                return clients[#clients].config.root_dir
              end
            end
            return ${util}.root_pattern('go.work', 'go.mod', '.git')(fname)
          end
        '';
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
        rootDir.__raw = ''
          function(fname)
            return ${util}.find_git_ancestor(fname)
          end
        '';
      };

      intelephense = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nodePackages_latest.intelephense;
        cmd = ["${pkgs.unstable.nodePackages_latest.intelephense}/bin/intelephense" "--stdio"];
        filetypes = ["php"];
        rootDir.__raw = ''
          function(pattern)
            local cwd = vim.loop.cwd()
            local root = ${util}.root_pattern('composer.json', '.git')(pattern)

            -- prefer cwd if root is a descendant
            return ${util}.path.is_descendant(cwd, root) and cwd or root
          end
        '';
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
        rootDir.__raw = ''
          function(fname)
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
              local root = ${util}.root_pattern(unpack(patterns))(fname)
              if root then
                return root
              end
            end
          end
        '';
        extraOptions = {
          init_options = {
            workspace.__raw = ''
              function()
                local cache_dir = os.getenv('XDG_CACHE_HOME') and os.getenv('XDG_CACHE_HOME') or ${util}.path.join(vim.loop.os_homedir(), '.cache')
                local jdtls_cache_dir = ${util}.path.join(cache_dir, 'jdtls')
                return ${util}.path.join(jdtls_cache_dir, 'workspace')
              end
            '';
          };
          handlers = {
            "textDocument/codeAction".__raw = ''
              function(err, actions, ctx)
                ${fixZeroVersion}
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
            '';
            "textDocument/rename".__raw = ''
              function(err, workspace_edit, ctx)
                ${fixZeroVersion}
                local handlers = require('vim.lsp.handlers')
                handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
              end
            '';
            "workspace/applyEdit".__raw = ''
              function(err, workspace_edit, ctx)
                ${fixZeroVersion}
                local handlers = require('vim.lsp.handlers')
                handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
              end
            '';
            "language/status".__raw = ''
              funtion()
                local function on_language_status(_, result)
                  local command = vim.api.nvim_command
                  command 'echohl ModeMsg'
                  command(string.format('echo "%s"', result.message))
                  command 'echohl None'
                end
                return vim.schedule_wrap(on_language_status)
              end
            '';
          };
        };
      };

      jsonls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.vscode-langservers-extracted;
        cmd = ["${pkgs.unstable.vscode-langservers-extracted}/bin/vscode-json-language-server" "--stdio"];
        filetypes = ["json" "jsonc"];
        extraOptions.init_options.provideFormatter = true;
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
        rootDir.__raw = ''
          function(fname)
            return ${util}.root_pattern('mix.exs')(fname) or ${util}.find_git_ancestor(fname)
          end
        '';
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
        extraOptions.get_language_id.__raw = ''
          function(_, filetype)
            local language_id_mapping = {
              bib = 'bibtex',
              plaintex = 'tex',
              rnoweb = 'rsweave',
              rst = 'restructuredtext',
              tex = 'latex',
              pandoc = 'markdown',
              text = 'plaintext',
            }
            local language_id = language_id_mapping[filetype]
            if language_id then
              return language_id
            else
              return filetype
            end
          end
        '';
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
        rootDir.__raw = ''
          function(fname)
            local root_files = {
              '.luarc.json',
              '.luarc.jsonc',
              '.luacheckrc',
              '.stylua.toml',
              'stylua.toml',
              'selene.toml',
              'selene.yml',
            }
            local root = ${util}.root_pattern(unpack(root_files))(fname)
            if root and root ~= vim.env.HOME then
              return root
            end
            root = ${util}.root_pattern 'lua/'(fname)
            if root then
              return root
            end
            return ${util}.find_git_ancestor(fname)
          end
        '';
      };

      marksman = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.marksman;
        cmd = ["${pkgs.unstable.marksman}/bin/marksman" "server"];
        filetypes = ["markdown" "markdown.mdx"];
        rootDir.__raw = ''
          function(fname)
            local root_files = { '.marksman.toml' }
            return ${util}.root_pattern(unpack(root_files))(fname) or ${util}.find_git_ancestor(fname)
          end
        '';
      };

      nginx-language-server = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.nginx-language-server;
        cmd = ["${pkgs.unstable.nginx-language-server}/bin/nginx-language-server"];
        filetypes = ["nginx"];
        rootDir.__raw = ''
          function(fname)
            return ${util}.root_pattern('nginx.conf', '.git')(fname) or ${util}.find_git_ancestor(fname)
          end
        '';
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
        rootDir.__raw = ''
          function(pattern)
            local cwd = vim.loop.cwd()
            local root = ${util}.root_pattern('composer.json', '.git', '.phpactor.json', '.phpactor.yml')(pattern)

            -- prefer cwd if root is a descendant
            return ${util}.path.is_descendant(cwd, root) and cwd or root
          end
        '';
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
        rootDir.__raw = ''
          function(fname)
            return ${util}.find_git_ancestor(fname) or vim.loop.os_homedir()
          end
        '';
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
        rootDir.__raw = ''
          function(fname)
            ${rust.isLibrary}
            local reuse_active = is_library(fname)
            if reuse_active then
              return reuse_active
            end

            local cargo_crate_dir = ${util}.root_pattern 'Cargo.toml'(fname)
            local cargo_workspace_root

            if cargo_crate_dir ~= nil then
              local cmd = {
                "${pkgs.unstable.cargo}/bin/cargo",
                'metadata',
                '--no-deps',
                '--format-version',
                '1',
                '--manifest-path',
                ${util}.path.join(cargo_crate_dir, 'Cargo.toml'),
              }

              local result = ${async}.run_command(cmd)

              if result and result[1] then
                result = vim.json.decode(table.concat(result, ""))
                if result['workspace_root'] then
                  cargo_workspace_root = ${util}.path.sanitize(result['workspace_root'])
                end
              end
            end

            return cargo_workspace_root
              or cargo_crate_dir
              or ${util}.root_pattern 'rust-project.json'(fname)
              or ${util}.find_git_ancestor(fname)
          end
        '';
        extraOptions = {
          capabilities.experimental.serverStatusNotification = true;
          before_init.__raw = ''
            function(init_params, config)
              -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
              if config.settings and config.settings['rust-analyzer'] then
                init_params.initializationOptions = config.settings['rust-analyzer']
              end
            end
          '';
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
          on_new_config.__raw = ''
            function(new_config)
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
          '';
        };
        rootDir.__raw = ''
          function(fname)
            return util.root_pattern(
              'tailwind.config.js',
              'tailwind.config.cjs',
              'tailwind.config.mjs',
              'tailwind.config.ts',
              'postcss.config.js',
              'postcss.config.cjs',
              'postcss.config.mjs',
              'postcss.config.ts'
            )(fname) or ${util}.find_package_json_ancestor(fname) or ${util}.find_node_modules_ancestor(fname) or ${util}.find_git_ancestor(
              fname
            )
          end
        '';
      };

      taplo = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.taplo;
        cmd = ["${pkgs.unstable.taplo}/bin/taplo" "lsp" "stdio"];
        filetypes = ["toml"];
        rootDir.__raw = ''util.find_git_ancestor'';
      };

      terraformls = {
        enable = true;
        autostart = true;
        package = pkgs.unstable.terraform-ls;
        cmd = ["${pkgs.unstable.terraform-ls}/bin/terraform-ls" "serve"];
        filetypes = ["terraform" "terraform-vars"];
        rootDir.__raw = ''util.root_pattern('.terraform', '.git')'';
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
        settings.redhat.telemetry.enabled = false;
      };
    };
  };
}
