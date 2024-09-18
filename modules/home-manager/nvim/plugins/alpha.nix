let
  button = {
    sc,
    txt,
    keybind ? "nil",
    keybind_opts ? "nil",
  }: {
    type = "button";
    val = ''
      function(${sc}, ${txt}, ${keybind}, ${keybind_opts})
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

        local opts = {
            position = "center",
            shortcut = sc,
            cursor = 3,
            width = 50,
            align_shortcut = "right",
            hl = "AlphaButton"
            hl_shortcut = "AlphaShortcut"
        }
        if keybind then
            keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
            opts.keymap = { "n", sc_, keybind, keybind_opts }
        end

        local function on_press()
            local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
            vim.api.nvim_feedkeys(key, "t", false)
        end

        return {
            type = "button",
            val = txt,
            on_press = on_press,
            opts = opts,
        }
      end
    '';
  };
in {
  programs.nixvim.plugins.alpha = {
    enable = true;
    layout = [
      {
        type = "terminal";
        opts.redraw = true;
      }

      {
        type = "text";
        val = ''
          ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
          ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
          ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
          ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
          ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
          ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        '';
        opts = {
          position = "center";
          hl = "AlphaHeader";
        };
      }

      (button {
        sc = "e";
        txt = "  New file";
        keybind = "<cmd>ene <CR>";
      })
      (button {
        sc = "SPC f f";
        txt = "  Find Files";
      })
      (button {
        sc = "SPC f r";
        txt = "󱔗  Recent Files";
      })
      (button {
        sc = "SPC f t";
        txt = "󰈭  Find Text";
      })
      (button {
        sc = "SPC f p";
        txt = "  Find Projects";
      })
      (button {
        sc = "SPC f m";
        txt = "  Jump to bookmarks";
      })
      (button {
        sc = "SPC q";
        txt = "  Quit Neovim";
      })

      {
        type = "text";
        val = ''" " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch'';
        opts = {
          position = "center";
          hl = "AlphaFooter";
        };
      }
    ];
  };
}
