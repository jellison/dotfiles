-- Per-window filename label at the top of each split (winbar), so you can see
-- which file every window holds — focused and unfocused. Keeps the single
-- global statusline at the bottom.
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local function is_terminal()
        return vim.bo.buftype == "terminal"
      end

      local function disable_trouble_symbols_in_terminal(args)
        local bufnr = args and args.buf or vim.api.nvim_get_current_buf()
        if vim.bo[bufnr].buftype == "terminal" then
          vim.b[bufnr].trouble_lualine = false
        end
      end

      local terminal_statusline_group = vim.api.nvim_create_augroup("UserTerminalStatusline", { clear = true })
      vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
        group = terminal_statusline_group,
        callback = disable_trouble_symbols_in_terminal,
      })
      disable_trouble_symbols_in_terminal()

      local function add_not_terminal_cond(component)
        local old_cond = component.cond
        component.cond = function(...)
          return not is_terminal() and (old_cond == nil or old_cond(...))
        end
      end

      local fticon = { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } }
      local fname = {
        "filename",
        path = 1, -- relative path (disambiguates same-named files)
        symbols = { modified = " ●", readonly = " ", newfile = " " },
      }

      for _, component in ipairs(vim.tbl_get(opts, "sections", "lualine_y") or {}) do
        if type(component) == "table" and (component[1] == "progress" or component[1] == "location") then
          add_not_terminal_cond(component)
        end
      end
      opts.winbar = { lualine_c = { fticon, fname } }
      opts.inactive_winbar = { lualine_c = { fticon, fname } }

      -- Don't draw the winbar in utility/special windows.
      opts.options = opts.options or {}
      local df = opts.options.disabled_filetypes or {}
      if type(df) ~= "table" then
        df = {}
      end
      if df[1] ~= nil then -- was a plain list -> normalize
        df = { statusline = df }
      end
      df.winbar = {
        "neo-tree",
        "snacks_picker_list",
        "snacks_picker_input",
        "snacks_layout_box",
        "snacks_dashboard",
        "snacks_terminal",
        "Trouble",
        "trouble",
        "help",
        "qf",
        "lazy",
        "mason",
        "toggleterm",
        "TelescopePrompt",
        "oil",
      }
      opts.options.disabled_filetypes = df
    end,
  },
}
