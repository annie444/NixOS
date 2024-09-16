{
  which-key = {
    enable = true;
    settings = {
      delay = 200;
      expand = 1;
      notify = false;
      preset = false;
      replace = {
        desc = [
          [
            "<space>"
            "SPACE"
          ]
          [
            "<leader>"
            "SPACE"
          ]
          [
            "<[cC][rR]>"
            "RETURN"
          ]
          [
            "<[tT][aA][bB]>"
            "TAB"
          ]
          [
            "<[bB][sS]>"
            "BACKSPACE"
          ]
        ];
      };
      spec = [
        {
          __unkeyed-1 = "<leader>r";
          __unkeyed-2 = ":%d+<cr>";
          desc = "Remove All Text";
        }

        {
          __unkeyed-1 = "<leader>y";
          __unkeyed-2 = ":%y+<cr>";
          desc = "Yank All Text";
        }

        {
          __unkeyed-1 = "<leader>e";
          __unkeyed-2 = ":Neotree toggle<cr>";
          desc = "Explorer";
        }

        { 
          __unkeyed-1 = "<leader>D";
          __unkeyed-2.__raw = ''
            function()
              if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
                if vim.o.cmdheight ~= 0 or vim.o.laststatus ~= 0 or vim.o.showtabline ~= 0 then
                  vim.opt.cmdheight = 0
                  vim.opt.laststatus = 0
                  vim.opt.showtabline = 0
                else
                  vim.opt.cmdheight = 1
                  vim.opt.laststatus = 3
                  vim.opt.showtabline = 2
                end
              end
            end
          '';
          desc = "Distraction Free";
        }

        {
         __unkeyed-1 = "<leader>q";
         __unkeyed-2 = ":qa!<cr>";
         desc = "Quit";
      }

        {
         __unkeyed-1 = "<leader>c";
         __unkeyed-2 = ":Bdelete!<cr>";
         desc = "Close Buffer";
      }

        {
         __unkeyed-1 = "<leader>T";
         __unkeyed-2 = ":TSContextToggle<cr>";
         desc = "Toggle Context";
      }

        {
          __unkeyed-1 = "<leader>mp";
          __unkeyed-2.__raw = ''
            function()
              if vim.bo.filetype == "markdown" then
                vim.cmd "MarkdownPreviewToggle"
              else
                vim.notify("Only available in markdown", vim.log.levels.WARN, { title = "Markdown-Preview" })
              end
            end
          '';
          desc = "Markdown Preview";
        }

        { 
          __unkeyed-1 = "<leader>n";
          group = "Neovim";
        }

        {
         __unkeyed-1 = "<leader>nr";
         __unkeyed-2 = ":Reload<cr>";
         desc = "Core Reload";
      }

        {
         __unkeyed-1 = "<leader>nu";
         __unkeyed-2 = ":Update<cr>";
         desc = "Update";
      }

        {
         __unkeyed-1 = "<leader>nm";
         __unkeyed-2 = ":messages<cr>";
         desc = "Messages";
      }

        {
         __unkeyed-1 = "<leader>nh";
         __unkeyed-2 = ":checkhealth<cr>";
         desc = "Health";
      }

        {
          __unkeyed-1 = "<leader>nv";
          __unkeyed-2.__raw = ''
            function()
              local version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
              return vim.notify(version, vim.log.levels.INFO, { title = "Neovim Version" })
            end
          '';
          desc = "Version";
        }

        {
          __unkeyed-1 = "<leader>ni";
          __unkeyed-2.__raw = ''
            function()
              if vim.fn.has "nvim-0.9.0" == 1 then
                vim.cmd "Inspect"
              else
                vim.notify("Inspect isn't available in this neovim version", vim.log.levels.WARN, { title = "Inspect" })
              end
            end
          '';
          desc = "Inspect";
        }

        { 
          __unkeyed = "<leader>g";
          group = "Git";
        }

        {
         __unkeyed-1 = "<leader>gj";
         __unkeyed-2 = ":lua require 'gitsigns'.next_hunk()<cr>";
         desc = "Next Hunk";
      }

        {
         __unkeyed-1 = "<leader>gk";
         __unkeyed-2 = ":lua require 'gitsigns'.prev_hunk()<cr>";
         desc = "Prev Hunk";
      }

        {
         __unkeyed-1 = "<leader>gl";
         __unkeyed-2 = ":lua require 'gitsigns'.blame_line()<cr>";
         desc = "Blame";
      }

        {
         __unkeyed-1 = "<leader>gp";
         __unkeyed-2 = ":lua require 'gitsigns'.preview_hunk()<cr>";
         desc = "Preview Hunk";
      }

        {
         __unkeyed-1 = "<leader>gr";
         __unkeyed-2 = ":lua require 'gitsigns'.reset_hunk()<cr>";
         desc = "Reset Hunk";
      }

        {
         __unkeyed-1 = "<leader>gR";
         __unkeyed-2 = ":lua require 'gitsigns'.reset_buffer()<cr>";
         desc = "Reset Buffer";
      }

        {
         __unkeyed-1 = "<leader>gs";
         __unkeyed-2 = ":lua require 'gitsigns'.stage_hunk()<cr>";
         desc = "Stage Hunk";
      }

        {
         __unkeyed-1 = "<leader>gu";
         __unkeyed-2 = ":lua require 'gitsigns'.undo_stage_hunk()<cr>";
         desc = "Undo Stage Hunk";
      }

        {
         __unkeyed-1 = "<leader>go";
         __unkeyed-2 = ":Telescope git_status<cr>";
         desc = "Open changed file";
      }

        {
         __unkeyed-1 = "<leader>gb";
         __unkeyed-2 = ":Telescope git_branches<cr>";
         desc = "Checkout branch";
      }

        {
         __unkeyed-1 = "<leader>gc";
         __unkeyed-2 = ":Telescope git_commits<cr>";
         desc = "Checkout commit";
      }

        {
          __unkeyed-1 = "<leader>gd";
          __unkeyed-2.__raw = ''
            function()
              if next(require("diffview.lib").views) == nil then
                vim.cmd "DiffviewOpen"
              else
                vim.cmd "DiffviewClose"
              end
            end
          '';
          desc = "Toggle Diffview";
        }

        {
          __unkeyed-1 = "<leader>gg";
          __unkeyed-2.__raw = ''
            function()
              local Terminal = require("toggleterm.terminal").Terminal
              local lazygit = Terminal:new { cmd = "lazygit" }
              lazygit:toggle()
            end
          '';
          desc = "Lazygit";
        }

        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
          nowait = true;
          noremap = true;
        }

        {
           __unkeyed-1 = "<leader>lf";
           __unkeyed-2 = ":Format<cr>";
           desc = "Format";
        }

        {
           __unkeyed-1 = "<leader>la";
           __unkeyed-2 = ":Lspsaga code_action<cr>";
           desc = "Code Action";
        }

        {
           __unkeyed-1 = "<leader>li";
           __unkeyed-2 = ":LspInfo<cr>";
           desc = "Info";
        }

        {
           __unkeyed-1 = "<leader>lo";
           __unkeyed-2 = ":Lspsaga outline<cr>";
           desc = "Code Outline";
        }

        {
           __unkeyed-1 = "<leader>lI";
           __unkeyed-2 = ":Lspsaga incoming_calls<cr>";
           desc = "Incoming Calls";
        }

        {
           __unkeyed-1 = "<leader>lO";
           __unkeyed-2 = ":Lspsaga outgoing_calls<cr>";
           desc = "Outgoing Calls";
        }

        {
           __unkeyed-1 = "<leader>lm";
           __unkeyed-2 = ":Mason<cr>";
           desc = "Mason Installer";
        }

        {
           __unkeyed-1 = "<leader>lj";
           __unkeyed-2 = ":Lspsaga diagnostic_jump_next<cr>";
           desc = "Next Diagnostic";
        }

        {
           __unkeyed-1 = "<leader>lk";
           __unkeyed-2 = ":Lspsaga diagnostic_jump_prev<cr>";
           desc = "Prev Diagnostic";
        }

        {
           __unkeyed-1 = "<leader>lr";
           __unkeyed-2 = ":Lspsaga rename<cr>";
           desc = "Rename";
        }

        {
           __unkeyed-1 = "<leader>ld";
           __unkeyed-2 = ":Telescope diagnostics bufnr=0<cr>";
           desc = "Document Diagnostics";
        }

        {
           __unkeyed-1 = "<leader>lw";
           __unkeyed-2 = ":Telescope diagnostics<cr>";
           desc = "Workspace Diagnostics";
        }

        {
           __unkeyed-1 = "<leader>ls";
           __unkeyed-2 = ":Telescope lsp_document_symbols<cr>";
           desc = "Document Symbols";
        }

        {
           __unkeyed-1 = "<leader>lS";
           __unkeyed-2 = ":Telescope lsp_workspace_symbols<cr>";
           desc = "Workspace Symbols";
        }


        { 
          __unkeyed-1 = "<leader>f";
          group = "Find";
        }

        {
           __unkeyed-1 = "<leader>fa";
           __unkeyed-2 = ":Telescope autocommands<cr>";
           desc = "Autocommmands";
        }

        {
           __unkeyed-1 = "<leader>ff";
           __unkeyed-2 = ":Telescope find_files<cr>";
           desc = "Files";
        }

        {
           __unkeyed-1 = "<leader>ft";
           __unkeyed-2 = ":Telescope live_grep<cr>";
           desc = "Text";
        }

        {
           __unkeyed-1 = "<leader>fT";
           __unkeyed-2 = ":TodoTelescope<cr>";
           desc = "Todo";
        }

        {
           __unkeyed-1 = "<leader>fB";
           __unkeyed-2 = ":Telescope bookmarks<cr>";
           desc = "Browswer Bookmarks";
        }

        {
           __unkeyed-1 = "<leader>fb";
           __unkeyed-2 = ":Telescope buffers<cr>";
           desc = "Buffers";
        }

        {
           __unkeyed-1 = "<leader>fn";
           __unkeyed-2 = ":lua require('telescope').extensions.notify.notify()<cr>";
           desc = "Notify History";
        }

        {
           __unkeyed-1 = "<leader>fc";
           __unkeyed-2 = ":Telescope colorscheme<cr>";
           desc = "Colorscheme";
        }

        {
           __unkeyed-1 = "<leader>fp";
           __unkeyed-2 = ":Telescope projects<cr>";
           desc = "Projects";
        }

        {
           __unkeyed-1 = "<leader>fP";
           __unkeyed-2 = "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>";
           desc = "Colorscheme with Preview";
        }

        {
           __unkeyed-1 = "<leader>fs";
           __unkeyed-2 = ":Telescope persisted<cr>";
           desc = "Sessions";
        }

        {
           __unkeyed-1 = "<leader>fh";
           __unkeyed-2 = ":Telescope help_tags<cr>";
           desc = "Help";
        }

        {
           __unkeyed-1 = "<leader>fk";
           __unkeyed-2 = ":Telescope keymaps<cr>";
           desc = "Keymaps";
        }

        {
           __unkeyed-1 = "<leader>fC";
           __unkeyed-2 = ":Telescope commands<cr>";
           desc = "Commands";
        }

        {
           __unkeyed-1 = "<leader>fr";
           __unkeyed-2 = ":Telescope oldfiles<cr>";
           desc = "Recent Files";
        }

        {
           __unkeyed-1 = "<leader>fH";
           __unkeyed-2 = ":Telescope highlights<cr>";
           desc = "Highlights";
        }

        { 
          __unkeyed-1 = "<leader>t";
          group = "Terminal";
        }

        {
           __unkeyed-1 = "<leader>tt";
           __unkeyed-2 = ":ToggleTerm<cr>";
           desc = "Toggle";
        }

        {
           __unkeyed-1 = "<leader>th";
           __unkeyed-2 = ":ToggleTerm size=10 direction=horizontal<cr>";
           desc = "Horizontal";
        }

        {
           __unkeyed-1 = "<leader>tv";
           __unkeyed-2 = ":ToggleTerm size=50 direction=vertical<cr>";
           desc = "Vertical";
        }

        {
           __unkeyed-1 = "<leader>tf";
           __unkeyed-2 = ":ToggleTerm direction=float<cr>";
           desc = "Float";
        }

      ];
    };
  };
}
