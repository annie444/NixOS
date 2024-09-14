{}: let
  cmdlineConf = {
    mapping = {
      __raw = "cmp.mapping.preset.cmdline()";
    };
    sources = [
      { 
        name = "cmdline"; 
      }
      { 
        name = "cmdline_history"; 
      }
      { 
        name = "fuzzy_buffer";
      }
    ];
    window = {
      completion = {
        __raw = ''cmp.config.window.bordered {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:Search",
            col_offset = -3,
            side_padding = 1,
          }
        '';
      };
    };
  };
in {
  plugins.cmp = {
    autoEnableSources = true;
    settings.sources = [
      { name = "nvim_lsp"; }
      { name = "path"; }
      { name = "buffer"; }
    ];
    cmdline = {
      for _, cmd_type in ipairs({ ":", "/", "?", "@" }) do
       ,
        formatting = {
          format = function(_, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            return vim_item
          end,
        },
      })
    end
    }
  };
}
