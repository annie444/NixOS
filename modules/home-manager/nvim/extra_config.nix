{pkgs, ...}: let
  util = ''require("lspconfig.util")'';
  async = ''require('lspconfig.async')'';

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

  icons = builtins.readFile ./configs/icons.lua;
  noice = builtins.readFile ./configs/noice.lua;

  eslint = builtins.readFile ./configs/eslint.lua;
  go = builtins.readFile ./configs/go.lua;
  java = builtins.readFile ./configs/java.lua;
  ltex = builtins.readFile ./configs/ltex.lua;
  lua = builtins.readFile ./configs/lua.lua;
  markdown = builtins.readFile ./configs/markdown.lua;
  php = builtins.readFile ./configs/php.lua;
  rust = builtins.readFile ./configs/rust.lua;
  tailwind = builtins.readFile ./configs/tailwind.lua;
in {
  programs.nixvim.extraConfigLua =
    ''
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.amber = {
        install_info = {
          url = "${pkgs.treesitter-amber}",
          files = {"src/parser.c"},
          branch = "main",
          generate_requires_npm = true,
          requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
        },
        filetype = "ab",
      }

      ${reloadWorkspace}
      ${isLibrary}

      local function rust_root_dir(fname)
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

    ''
    + builtins.concatStringsSep "\n" [
      icons
      noice
      eslint
      go
      java
      ltex
      lua
      markdown
      php
      rust
      tailwind
    ];
}
