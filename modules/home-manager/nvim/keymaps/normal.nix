{
  self,
  lib,
  ...
}: {
  self = lib.lists.forEach [
    { 
      key = "<leader>ji";
      action = "<cmd>MagmaInit<CR>";
      options.desc = "This command initializes a runtime for the current buffer.";
    }
    
    { 
      key = "<leader>jo";
      action = "<cmd>MagmaEvaluateOperator<CR>";
      options.desc = "Evaluate the text given by some operator.";
    }

    { 
      key = "<leader>jl";
      action = "<cmd>MagmaEvaluateLine<CR>";
      options.desc = "Evaluate the current line.";
    }

    { 
      key = "<leader>jv";
      action = "<cmd>MagmaEvaluateVisual<CR>";
      options.desc = "Evaluate the selected text.";
    }

    { 
      key = "<leader>jc";
      action = "<cmd>MagmaEvaluateOperator<CR>";
      options.desc = "Reevaluate the currently selected cell.";
    }

    { 
      key = "<leader>jr";
      action = "<cmd>MagmaRestart!<CR>";
      options.desc = "Shuts down and restarts the current kernel.";
    }

    {
      key = "<leader>jx";
      action = "<cmd>MagmaInterrupt<CR>";
      options.desc = "Interrupts the currently running cell and does nothing if not cell is running.";
    }

    {
      key = "<leader>Pv";
      action = ":lua VimtexPDFToggle()<cr>";
    }

    {
      key = "<leader>gau";
      action.__raw = ''
        function()
          require('textcase').current_word('to_upper_case')
        end
      '';
    }
    {
      key = "<leader>gal";
      action.__raw = ''
        function()
          require('textcase').current_word('to_lower_case')
        end
      '';
    }
    {
      key = "<leader>gas";
      action.__raw = ''
        function()
          require('textcase').current_word('to_snake_case')
        end
      '';
    }
    {
      key = "<leader>gad";
      action.__raw = ''
        function()
          require('textcase').current_word('to_dash_case')
        end
      '';
    }
    {
      key = "<leader>gan";
      action.__raw = ''
        function()
          require('textcase').current_word('to_constant_case')
        end
      '';
    }
    {
      key = "<leader>gaa";
      action.__raw = ''
        function()
          require('textcase').current_word('to_phrase_case')
        end
      '';
    }
    {
      key = "<leader>gac";
      action.__raw = ''
        function()
          require('textcase').current_word('to_camel_case')
        end
      '';
    }
    {
      key = "<leader>gap";
      action.__raw = ''
        function()
          require('textcase').current_word('to_pascal_case')
        end
      '';
    }
    {
      key = "<leader>gat";
      action.__raw = ''
        function()
          require('textcase').current_word('to_title_case')
        end
      '';
    }
    {
      key = "<leader>gaf";
      action.__raw = ''
        function()
          require('textcase').current_word('to_path_case')
        end
      '';
    }
    {
      key = "<leader>gaU";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_upper_case')
        end
      '';
    }
    {
      key = "<leader>gaL";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_lower_case')
        end
      '';
    }
    {
      key = "<leader>gaS";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_snake_case')
        end
      '';
    }
    {
      key = "<leader>gaD";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_dash_case')
        end
      '';
    }
    {
      key = "<leader>gaN";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_constant_case')
        end
      '';
    }
    {
      key = "<leader>gaA";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_phrase_case')
        end
      '';
    }
    {
      key = "<leader>gaC";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_camel_case')
        end
      '';
    }
    {
      key = "<leader>gaP";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_pascal_case')
        end
      '';
    }
    {
      key = "<leader>gaT";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_title_case')
        end
      '';
    }
    {
      key = "<leader>gaF";
      action.__raw = ''
        function()
          require('textcase').lsp_rename('to_path_case')
        end
      '';
    }
    {
      key = "<leader>geu";
      action.__raw = ''
        function()
          require('textcase').operator('to_upper_case')
        end
      '';
    }
    {
      key = "<leader>gel";
      action.__raw = ''
        function()
          require('textcase').operator('to_lower_case')
        end
      '';
    }
    {
      key = "<leader>ges";
      action.__raw = ''
        function()
          require('textcase').operator('to_snake_case')
        end
      '';
    }
    {
      key = "<leader>ged";
      action.__raw = ''
        function()
          require('textcase').operator('to_dash_case')
        end
      '';
    }
    {
      key = "<leader>gen";
      action.__raw = ''
        function()
          require('textcase').operator('to_constant_case')
        end
      '';
    }
    {
      key = "<leader>gea";
      action.__raw = ''
        function()
          require('textcase').operator('to_phrase_case')
        end
      '';
    }
    {
      key = "<leader>gec";
      action.__raw = ''
        function()
          require('textcase').operator('to_camel_case')
        end
      '';
    }
    {
      key = "<leader>gep";
      action.__raw = ''
        function()
          require('textcase').operator('to_pascal_case')
        end
      '';
    }
    {
      key = "<leader>get";
      action.__raw = ''
        function()
          require('textcase').operator('to_title_case')
        end
      '';
    }
    {
      key = "<leader>gef";
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
      key = "<leader>d";
      action = "\"_d";
      options = {
        desc = "Delete";
        remap = false;
      };
    }
    {
      key = "<leader>j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Better Down";
        expr = true;
        silent = true;
      };
    }
    {
      key = "<leader>k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Better Up";
        expr = true;
        silent = true;
      };
    }
    {
      key = "<leader><C-j>";
      action = "<C-w>j";
      options.desc = "Go to upper window";
    }
    {
      key = "<leader><C-k>";
      action = "<C-w>k";
      options.desc = "Go to lower window";
    }
    {
      key = "<leader><C-h>";
      action = "<C-w>h";
      options.desc = "Go to left window";
    }
    {
      key = "<leader><C-l>";
      action = "<C-w>l";
      options.desc = "Go to right window";
    }
    {
      key = "<leader>;";
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
      key = "<leader><C-Up>";
      action = ":resize +2<CR>";
      options.desc = "Add size at the top";
    }
    {
      key = "<leader><C-Down>";
      action = ":resize -2<CR>";
      options.desc = "Add size at the bottom";
    }
    {
      key = "<leader><C-Left>";
      action = ":vertical resize +2<CR>";
      options.desc = "Add size at the left";
    }
    {
      key = "<leader><C-Right>";
      action = ":vertical resize -2<CR>";
      options.desc = "Add size at the right";
    }
    {
      key = "<leader>H";
      action = ":bprevious<CR>";
      options.desc = "Go to previous buffer";
    }
    {
      key = "<leader>L";
      action = ":bnext<CR>";
      options.desc = "Go to next buffer";
    }
    {
      key = "<leader><Left>";
      action = ":tabprevious<CR>";
      options.desc = "Go to previous tab";
    }
    {
      key = "<leader><Right>";
      action = ":tabnext<CR>";
      options.desc = "Go to next tab";
    }
    {
      key = "<leader><Up>";
      action = ":tabnew<CR>";
      options.desc = "New tab";
    }
    {
      key = "<leader><Down>";
      action = ":tabclose<CR>";
      options.desc = "Close tab";
    }
    {
      key = "<leader><A-j>";
      action = ":m .+1<CR>==";
      options.desc = "Move the line up";
    }
    {
      key = "<leader><A-k>";
      action = ":m .-2<CR>==";
      options.desc = "Move the line down";
    }
  ] (k: k // {mode = ["n"];});
}
