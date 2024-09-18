{pkgs, ...}: {
  programs.nixvim.autoCmd = [
    {
      event = "FileType";
      pattern = [
        "help"
        "alpha"
        "dashboard"
        "neo-tree"
        "Trouble"
        "mason"
        "notify"
        "toggleterm"
        "lazyterm"
      ];
      callback.__raw = ''
        function()
          vim.b.miniindentscope_disable = true
        end
      '';
    }

    {
      event = "BufNewFile";
      pattern = [
        "*.md"
      ];
      command = ":r! echo \\# %:t:r";
    }

    {
      event = "BufNewFile";
      pattern = ["*.md"];
      command = ":norm kddo";
    }

    {
      event = [
        "BufRead"
        "BufNewFile"
      ];
      pattern = [
        "os.getenv(\"HOME\") .. \"/.local/share/chezmoi/*\""
      ];
      callback.__raw = ''
        function()
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end
      '';
    }

    {
      event = "VimEnter";
      callback.__raw = ''
        function(data)
          -- buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1

          -- change to the directory
          if directory then
            vim.cmd.cd(data.file)
            -- open the tree
            require("neo-tree.command").execute({
              action = "focus",
              source = "filesystem",
              position = "left",
              toggle = true,
              reveal = true,
              dir = data.file
            })
          end
        end
      '';
      group = "general";
      desc = "Open NeoTree when it's a Directory";
    }

    {
      event = "CustomTex";
    }

    {
      event = "User";
      group = "CustomTex";
      pattern = "VimtexEventCompileSuccess";
      callback.__raw = ''
        function()
          vim.g.tex_compiles_successfully = true
          if vim.g.term_pdf_vierer_open and vim.g.tex_compiles_successfully then
            vim.notify("Reloading PDF", vim.log.levels.INFO, { title = "TeX" })
            local kitty = { "${pkgs.kitty}", "@", "send-text", "--match", "title:termpdf", vim.g.python3_host_prog,
              "-m", "termpdf", vim.api.nvim_call_function("expand", { "%:r" }) .. ".pdf", '\r' }
            vim.system(kitty)
          end
        end
      '';
    }

    {
      event = "User";
      group = "CustomTex";
      pattern = "VimtexEventCompileFailed";
      callback.__raw = ''
        function()
          vim.notify("Pausing PDF reload until successful compilation", vim.log.levels.ERROR, { title = "TeX" })
          vim.g.tex_compiles_successfully = false
        end
      '';
    }

    {
      event = "User";
      group = "CustomTex";
      pattern = "VimtexEventQuit";
      callback.__raw = ''
        function()
          vim.notify("Closing PDF viewer", vim.log.levels.WARN, { title = "TeX" })
          vim.system({ "${pkgs.kitty}", "@", "close-window", "--match", "title:termpdf" })
        end
      '';
    }

    {
      event = "FileType";
      pattern = "sagaoutline";
      callback.__raw = ''
        function()
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.stc = ""
        end
      '';
    }

    {
      event = [
        "BufReadPost"
        "BufNewFile"
      ];
      once = true;
      callback.__raw = ''
        function()
          vim.opt.clipboard = "unnamedplus"
        end
      '';
      group = "General Settings";
      desc = "Lazy load clipboard";
    }

    {
      event = "TermOpen";
      callback.__raw = ''
        function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.cmd "startinsert!"
        end
      '';
      group = "General Settings";
      desc = "Terminal Options";
    }

    {
      event = "BufReadPost";
      callback.__raw = ''
        function()
          if fn.line "'\"" > 1 and fn.line "'\"" <= fn.line "$" then
            vim.cmd 'normal! g`"'
          end
        end
      '';
      group = "General Settings";
      desc = "Go To The Last Cursor Position";
    }

    {
      event = "TextYankPost";
      callback.__raw = ''
        function()
          require("vim.highlight").on_yank { higroup = "YankHighlight", timeout = 200 }
        end
      '';
      group = "General Settings";
      desc = "Highlight when yanking";
    }

    {
      event = "BufEnter";
      callback = ''
        function()
          vim.opt.formatoptions:remove { "c", "r", "o" }
        end
      '';
      group = "General Settings";
      desc = "Disable New Line Comment";
    }

    {
      event = "FileType";
      pattern = [
        "c"
        "cpp"
        "py"
        "java"
        "cs"
      ];
      callback.__raw = ''
        function()
          vim.bo.shiftwidth = 4
        end
      '';
      group = "General Settings";
      desc = "Set shiftwidth to 4 in these filetypes";
    }

    {
      event = [
        "FocusLost"
        "BufLeave"
        "BufWinLeave"
        "InsertLeave"
      ];
      callback.__raw = ''
        function()
          vim.cmd "silent! w"
        end
      '';
      group = "General Settings";
      desc = "Auto Save";
    }

    {
      event = "FocusGained";
      callback.__raw = ''
        function()
          vim.cmd "checktime"
        end
      '';
      group = "General Settings";
      desc = "Update file when there are changes";
    }

    {
      event = "VimResized";
      callback.__raw = ''
        function()
          vim.cmd "wincmd ="
        end
      '';
      group = "General Settings";
      desc = "Equalize Splits";
    }

    {
      event = "ModeChanged";
      callback.__raw = ''
        function()
          if fn.getcmdtype() == "/" or fn.getcmdtype() == "?" then
            vim.opt.hlsearch = true
          else
            vim.opt.hlsearch = false
          end
        end
      '';
      group = "General Settings";
      desc = "Highlighting matched words when searching";
    }

    {
      event = "FileType";
      pattern = [
        "gitcommit"
        "markdown"
        "text"
        "log"
      ];
      callback.__raw = ''
        function()
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
        end
      '';
      group = "General Settings";
      desc = "Enable Wrap in these filetypes";
    }
  ];
}
