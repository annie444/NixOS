{}: let
  added = "#67B0E8";
  delete = "#E57474";
  change = "#C47FD5";
  error = "#E57474";
  warn = "#E5C76B";
  hint = "#8CCF7E";
  foreground = {
    __raw = ''
      function()
        if vim.o.background == "dark" then
          foreground = "#5A5D61"
        else
          foreground = "#000000"
        end
        return foreground
      end
    '';
  };
  background = {
    __raw = ''
      function()
        if vim.o.background == "dark" then
          background = "#0F1416"
        else
          background = ""
        end
        return background 
      end
    '';
  };
in {
  lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        icons_enabled = true;
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = { 
          left = "";
          right = "";
        };
        theme = {
          normal = {
            a = { 
              fg = "#000000";
              bg = "#7AA2F7";
            };
            b = {
              bg = "#0F1416";
              fg = "#5A5D61"
            };
            c = {
              bg = "NONE";
              fg = "#5A5D61";
            };
          };

          insert = {
            a = {
              fg = "#000000";
              bg = "#98BE65";
            };
            b = {
              bg = "#0F1416";
              fg = "#5A5D61";
            };
          };

          command = {
            a = {
              fg = "#000000";
              bg = "#ECBE7B";
            };
            b = {
              bg = "#0F1416";
              fg = "#5A5D61";
            };
          };

          visual = {
            a = {
              fg = "#000000";
              bg = "#C678DD";
            };
            b = {
              bg = "#0F1416";
              fg = "#5A5D61";
            };
          };

          replace = {
            a = {
              fg = "#000000";
              bg = "#DB4B4B";
            };
            b = {
              bg = "#0F1416";
              fg = "#5A5D61";
            };
          };

          terminal = {
            a = {
              fg = "#000000";
              bg = "#7AA2F7";
            };
            b = {
              bg = "#0F1416";
              fg = "#5A5D61";
            };
          };

          inactive = {
            a = {
              fg = "#000000";
              bg = "#BBC2CF";
            };
            b = {
              bg = "NONE";
              fg = "#BBC2CF";
            };
            c = {
              bg = "NONE";
              fg = "#BBC2CF";
            };
          };
        };

        disabled_filetypes = [
          "dashboard"
          "lspinfo"
          "mason"
          "startuptime"
          "checkhealth"
          "help"
          "toggleterm"
          "alpha"
          "lazy"
          "packer"
          "NvimTree"
          "sagaoutline"
        ];
        always_divide_middle = true;
      };

      sections = {

        lualine_c = [
          {
            __unkeyed-1.__raw = ''
              function()
                local mode_names = require("plugins.lualine.modes").name
                local mode_name = vim.api.nvim_get_mode().mode
                if mode_names[mode_name] == nil then
                  return mode_name
                end
                return mode_names[mode_name]
              end
            '';
            separator = {
              right = "";
              left = "";
            };
            color.__raw = ''
              function()
                return { bg = mode_color[vim.api.nvim_get_mode().mode], fg = "Black" }
              end
            '';
          }

          {
            __unkeyed = "branch";
            icons_enabled = true;
            separator = {
              right = "";
              left = "";
            };
            color = {
              fg = foreground;
              bg = background;
            };
            icon = " ";
          }

          {
            __unkeyed-1 = "diff";
            symbols = { 
              added = " ";
              modified = " ";
              removed = " ";
            };
            diff_color = {
              added.fg = added;
              modified.fg = change;
              removed.fg = delete;
            };
            cond.__raw = ''
              function()
                return vim.fn.winwidth(0) > 80
              end
            '';
            color = { 
              fg = foreground;
              bg = "NONE";
            };
          }

          "%="

          {
            __unkeyed-1 = "filename";
            icon = "";
            color = { 
              fg = foreground;
              bg = background;
            };
            separator = { 
              right = "";
              left = "";
            };
            path = 4;
          }
        ];

        lualine_x = [
          {
            __unkeyed-1.__raw = ''require("noice").api.statusline.mode.get'';
            cond.__raw = ''require("noice").api.statusline.mode.has'';
          }

          {
            __unkeyed-1.__raw = ''require("lazy.status").updates'';
            cond.__raw = ''require("lazy.status").has_updates'';
          }

          {
            __unkeyed-1 = "diagnostics";
            sources = [ 
              "nvim_diagnostic"
            ];
            sections = [ 
              "error"
              "warn" 
              "hint" 
            ];
            symbols = { 
              error = " ";
              warn = " ";
              hint = "󰌵 ";
            };
            diagnostics_color = {
              error.fg = error;
              warn.fg = warn;
              hint.fg = hint;
            };
            update_in_insert = false;
            always_visible = false;
            color = { 
              fg = foreground;
              bg = "NONE";
            };
          }

          {
            __unkeyed-1.__raw = ''
              function()
                -- Initialize an empty table to store client names
                local clients = {}

                -- Iterate through all the clients for the current buffer
                for _, client in pairs(vim.lsp.buf_get_clients()) do
                  -- Skip the client if its name is "null-ls"
                  if client.name ~= "null-ls" then
                    -- Add the client name to the `clients` table
                    table.insert(clients, client.name)
                  end
                end

                -- Call the `list_registered_formatters` function and store the result and error (if any)
                local formatters_ok, supported_formatters, _ = pcall(list_registered_formatters, vim.bo.filetype)

                -- Call the `list_registered_linters` function and store the result and error (if any)
                local linters_ok, supported_linters = pcall(list_registered_linters, vim.bo.filetype)

                -- If the call to `list_registered_formatters` was successful and there are more than 0 formatters registered
                if formatters_ok and #supported_formatters > 0 then
                  -- Extend the `clients` table with the registered formatters
                  vim.list_extend(clients, supported_formatters)
                end

                -- If the call to `list_registered_linters` was successful and there are more than 0 linters registered
                if linters_ok and #supported_linters > 0 then
                  -- Extend the `clients` table with the registered linters
                  vim.list_extend(clients, supported_linters)
                end

                -- If there are more than 0 clients in the `clients` table
                if #clients > 0 then
                  -- Return the clients concatenated as a string, separated by commas
                  return table.concat(clients, ", ")
                else
                  -- Return the message "LS Inactive" if there are no clients
                  return "LS Inactive"
                end
              end
            '';
            separator = { 
              right = "";
              left = ""
            };
            color = { 
              fg = foreground;
              bg = background;
            };
          }

          {
            __unkeyed-1.__raw = ''
              function()
                local function format_file_size(file)
                  local size = vim.fn.getfsize(file)
                  if size <= 0 then
                    return ""
                  end
                  local sufixes = { " B", " KB", " MB", " GB" }
                  local i = 1
                  while size > 1024 do
                    size = size / 1024
                    i = i + 1
                  end
                  return string.format("%.1f%s", size, sufixes[i])
                end

                local file = vim.fn.expand "%:p"
                if string.len(file) == 0 then
                  return ""
                end
                return format_file_size(file)
              end
            '';
            color = { 
              fg = foreground;
              bg = "NONE";
            };
          }

          {
            __unkeyed-1 = "progress";
            color.__raw = ''
              function()
                return { bg = mode_color[vim.api.nvim_get_mode().mode], fg = "Black" }
              end
            '';
            separator = { 
              right = "";
              left = "";
            };
          }

          {
            __unkeyed-1.__raw = ''
              function()
                local current_line = vim.fn.line "."
                local total_lines = vim.fn.line "$"
                local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
                local line_ratio = current_line / total_lines
                local index = math.ceil(line_ratio * #chars)
                return chars[index]
              end
            '';
            color = { 
              fg = foreground;
              bg = "NONE";
            };
          }

          {
            __unkeyed-1.__raw = ''
              function()
                return "%L"
              end
            '';
            color.__raw = ''
              function()
                return { bg = mode_color[vim.api.nvim_get_mode().mode], fg = "Black" }
              end
            '';
            separator = { 
              right = "";
              left = "";
            };
          }
        ];
      };
    };
  };
}
