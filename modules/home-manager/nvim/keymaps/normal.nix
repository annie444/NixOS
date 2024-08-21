{
  self,
  lib,
  ...
}: {
  self = lib.lists.forEach [
    {
      key = "<leader>Pv";
      action = ":lua VimtexPDFToggle()<cr>";
    }
    {
      key = "gau";
      action.__raw = ''
        function()
          require('textcase').current_word('to_upper_case')
        end
      '';
    }
    {
      key = "gal";
      action.__raw = ''
        function()
          require('textcase').current_word('to_lower_case')
        end
      '';
    }
    {
      key = "gas";
      action.__raw = ''
        function()
          require('textcase').current_word('to_snake_case')
        end
      '';
    }
    {
      key = "gad";
      action.__raw = ''
        function()
          require('textcase').current_word('to_dash_case')
        end
      '';
    }
    {
      key = "gan";
      action.__raw = ''
        function()
          require('textcase').current_word('to_constant_case')
        end
      '';
    }
    {
      key = "gaa";
      action.__raw = ''
        function()
          require('textcase').current_word('to_phrase_case')
        end
      '';
    }
    {
      key = "gac";
      action.__raw = ''
        function()
          require('textcase').current_word('to_camel_case')
        end
      '';
    }
    {
      key = "gap";
      action.__raw = ''
        function()
          require('textcase').current_word('to_pascal_case')
        end
      '';
    }
    {
      key = "gat";
      action.__raw = ''
        function()
          require('textcase').current_word('to_title_case')
        end
      '';
    }
    {
      key = "gaf";
      action.__raw = ''
        function()
          require('textcase').current_word('to_path_case')
        end
      '';
    }
    {
      key = "gaU";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_upper_case')
        end
      '';
    }
    {
      key = "gaL";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_lower_case')
        end
      '';
    }
    {
      key = "gaS";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_snake_case')
        end
      '';
    }
    {
      key = "gaD";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_dash_case')
        end
      '';
    }
    {
      key = "gaN";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_constant_case')
        end
      '';
    }
    {
      key = "gaA";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_phrase_case')
        end
      '';
    }
    {
      key = "gaC";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_camel_case')
        end
      '';
    }
    {
      key = "gaP";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_pascal_case')
        end
      '';
    }
    {
      key = "gaT";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_title_case')
        end
      '';
    }
    {
      key = "gaF";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_path_case')
        end
      '';
    }
    {
      key = "geu";
      action.__raw = ''
        function()
          require('textcase').operator('to_upper_case')
        end
      '';
    }
    {
      key = "gel";
      action.__raw = ''
        function()
          require('textcase').operator('to_lower_case')
        end
      '';
    }
    {
      key = "ges";
      action.__raw = ''
        function()
          require('textcase').operator('to_snake_case')
        end
      '';
    }
    {
      key = "ged";
      action.__raw = ''
        function()
          require('textcase').operator('to_dash_case')
        end
      '';
    }
    {
      key = "gen";
      action.__raw = ''
        function()
          require('textcase').operator('to_constant_case')
        end
      '';
    }
    {
      key = "gea";
      action.__raw = ''
        function()
          require('textcase').operator('to_phrase_case')
        end
      '';
    }
    {
      key = "gec";
      action.__raw = ''
        function()
          require('textcase').operator('to_camel_case')
        end
      '';
    }
    {
      key = "gep";
      action.__raw = ''
        function()
          require('textcase').operator('to_pascal_case')
        end
      '';
    }
    {
      key = "get";
      action.__raw = ''
        function()
          require('textcase').operator('to_title_case')
        end
      '';
    }
    {
      key = "gef";
      action.__raw = ''
        function()
          require('textcase').operator('to_path_case')
        end
      '';
    }
    {
      key = "<leader>i";
      action = ":VimwikiToggleListItem<cr>";
      options.desc = "Toggle list item";
    }
    {
      key = "<leader>k";
      action = ":VimwikiIncrementListItem<cr>";
      options.desc = "Increment list item";
    }
    {
      key = "<leader>s";
      action = "?#<space><cr>jV}k :sort!<cr>:let @/=''<cr>";
      options.desc = "Sort list items";
    }
    {
      key = "<leader>.";
      action = "lua require('lsp_lines').toggle()";
      options.desc = "Toggle LSP Lines";
    }
    {
      key = "<leader>gg";
      action = "LazyGit";
      options.desc = "LazyGit";
    }
    {
      key = "<leader>gj";
      action = "LazyGitConfig";
      options.desc = "LazyGit Config";
    }
    {
      key = "<leader>gc";
      action = "LazyGitFilterCurrentFile";
      options.desc = "LazyGit Config Edit";
    }
    {
      key = "<leader>jd";
      action = "MagmaDeinit";
      options.desc = "Deinit Magma";
    }
    {
      key = "<leader>je";
      action = "MagmaEvaluateLine";
      options.desc = "Evaluate Line";
    }
    {
      key = "<leader>jr";
      action = "MagmaReevaluateCell";
      options.desc = "Re evaluate cell";
    }
    {
      key = "<leader>jD";
      action = "MagmaDelete";
      options.desc = "Delete cell";
    }
    {
      key = "<leader>js";
      action = "MagmaShowOutput";
      options.desc = "Show Output";
    }
    {
      key = "<leader>jR";
      action = "MagmaRestart!";
      options.desc = "Restart Magma";
    }
    {
      key = "<leader>jS";
      action = "MagmaSave";
      options.desc = "Save";
    }
    {
      key = "<leader>Pw";
      action = "lua require('swenv').toggle()";
      options.desc = "Toggle SwEnv";
    }
    {
      key = "<leader>Pi";
      action = "lua require('swenv.api').pick_venv()";
      options.desc = "Pick Env";
    }
    {
      key = "<leader>Pd";
      action = "lua require('swenv.api').get_current_venv()";
      options.desc = "Show Env";
    }
    {
      key = "d";
      action = "\"_d";
      options = {
        desc = "Delete";
        remap = false;
      };
    }
    {
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Better Down";
        expr = true;
        silent = true;
      };
    }
    {
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Better Up";
        expr = true;
        silent = true;
      };
    }
    {
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Go to upper window";
    }
    {
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Go to lower window";
    }
    {
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Go to left window";
    }
    {
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Go to right window";
    }
    {
      key = ";";
      action.__raw = ''
        function()
          if vim.bo.buftype == "terminal" then
            vim.cmd "Bdelete!"
            vim.cmd "silent! close"
          elseif #vim.api.nvim_list_wins() > 1 then
            vim.cmd "silent! close"
          else
            vim.notify("Can't Close Window", vim.log.levels.WARN, { title = "Close Window" })
          end
        end
      '';
      options.desc = "Close window";
    }
    {
      key = "<C-Up>";
      action = ":resize +2<CR>";
      options.desc = "Add size at the top";
    }
    {
      key = "<C-Down>";
      action = ":resize -2<CR>";
      options.desc = "Add size at the bottom";
    }
    {
      key = "<C-Left>";
      action = ":vertical resize +2<CR>";
      options.desc = "Add size at the left";
    }
    {
      key = "<C-Right>";
      action = ":vertical resize -2<CR>";
      options.desc = "Add size at the right";
    }
    {
      key = "H";
      action = ":bprevious<CR>";
      options.desc = "Go to previous buffer";
    }
    {
      key = "L";
      action = ":bnext<CR>";
      options.desc = "Go to next buffer";
    }
    {
      key = "<Left>";
      action = ":tabprevious<CR>";
      options.desc = "Go to previous tab";
    }
    {
      key = "<Right>";
      action = ":tabnext<CR>";
      options.desc = "Go to next tab";
    }
    {
      key = "<Up>";
      action = ":tabnew<CR>";
      options.desc = "New tab";
    }
    {
      key = "<Down>";
      action = ":tabclose<CR>";
      options.desc = "Close tab";
    }
    {
      key = "<A-j>";
      action = ":m .+1<CR>==";
      options.desc = "Move the line up";
    }
    {
      key = "<A-k>";
      action = ":m .-2<CR>==";
      options.desc = "Move the line down";
    }
  ] (k: k // {mode = ["n"];});
}
