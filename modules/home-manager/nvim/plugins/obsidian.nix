{
  obsidian = {
    enable = true;
    settings = {
      workspaces.__raw = "vim.g.obsidian_workspaces";
      daily_notes = {
        folder = "Notes/Dailies";
        date_format = "%Y-%m-%d";
        alias_format = "%B %-d, %Y";
        template = "0B_01_Periodics/Daily.md";
      };
      notes_subdir = "Notes";
      log_level.__raw = "vim.log.levels.INFO";
      new_notes_location = "notes_subdir";
      completion = {
        nvim_cmp = true;
        min_chars = 2;
      };
      wiki_link_func = "prepend_note_id";
      templates = {
        subdir = "Templates";
        date_format = "%Y-%m-%d-%a";
        time_format = "%H:%M";
      };

      mappings = {
        "gf" = {
          action.__raw = ''
            function()
              return require("obsidian").util.gf_passthrough()
            end
          '';
          opts = { 
            noremap = false;
            expr = true;
            buffer = true;
          };
        };
        "<leader>ch" = {
          action.__raw = ''
            function()
              return require("obsidian").util.toggle_checkbox()
            end
          '';
          opts.buffer = true;
        };
        "<cr>" = {
          action.__raw = ''
            function()
              return require("obsidian").util.smart_action()
            end
          '';
          opts = { 
            buffer = true;
            expr = true;
          };
        };
      };

      note_id_func.__raw = ''
        function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      '';

      disable_frontmatter = false;

      note_frontmatter_func.__raw = ''
        function(note)
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end
      '';

      follow_url_func.__raw = ''
        function(url)
          vim.fn.jobstart({ "open", url }) -- Mac OS
          -- vim.fn.jobstart({"xdg-open", url})  -- linux
        end
      '';

      note_path_func.__raw = ''
        function(spec)
          local path = spec.dir / tostring(spec.id)
          return path:with_suffix(".md")
        end
      '';

      markdown_link_func.__raw = ''
        function(opts)
          return require("obsidian.util").markdown_link(opts)
        end
      '';

      preferred_link_style = "wiki";

      image_name_func.__raw = ''
        function()
          -- Prefix image names with timestamp.
          return string.format("%s-", os.time())
        end
      '';

      use_advanced_uri = false;

      open_app_foreground = false;

      finder = "telescope.nvim";

      sort_by = "modified";
      sort_reversed = true;

      open_notes_in = "current";

      picker = {
        name = "telescope.nvim";
        mappings = {
          new = "<C-x>";
          insert_link = "<C-l>";
        };
      };

      ui = {
        enable = true;
        update_debounce = 200;
        checkboxes = {
          " " = { 
            char = "󰄱";
            hl_group = "ObsidianTodo";
          };
          "x" = {
            char = ""; 
            hl_group = "ObsidianDone";
          },
          ">" = {
            char = "";
            hl_group = "ObsidianRightArrow";
          };
          "~" = {
            char = "󰰱";
            hl_group = "ObsidianTilde";
          };
        };
        external_link_icon = {
          char = "";
          hl_group = "ObsidianExtLinkIcon";
        };
        reference_text.hl_group = "ObsidianRefText";
        highlight_text.hl_group = "ObsidianHighlightText";
        tags.hl_group = "ObsidianTag";
        hl_groups = {
          ObsidianTodo = {
            bold = true;
            fg = "#f78c6c";
          };
          ObsidianDone = {
            bold = true;
            fg = "#89ddff";
          };
          ObsidianRightArrow = {
            bold = true;
            fg = "#f78c6c";
          };
          ObsidianTilde = { 
            bold = true;
            fg = "#ff5370";
          };
          ObsidianRefText = { 
            underline = true;
            fg = "#c792ea";
          };
          ObsidianExtLinkIcon.fg = "#c792ea";
          ObsidianTag = { 
            italic = true;
            fg = "#89ddff"; 
          };
          ObsidianHighlightText.bg = "#75662e";
        };
      };
      attachments = {
        img_folder = "Assets/Imgs";
        img_text_func.__raw = ''
          function(client, path)
            path = client:vault_relative_path(path) or path
            return string.format("![%s](%s)", path.name, path)
          end
        '';
      };
    };
  };
}
