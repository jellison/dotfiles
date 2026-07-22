-- Per-window filename label at the top of each split (winbar), so you can see
-- which file every window holds — focused and unfocused. Keeps the single
-- global statusline at the bottom.
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local fticon = { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } }
      local fname = {
        "filename",
        path = 1, -- relative path (disambiguates same-named files)
        symbols = { modified = " ●", readonly = " ", newfile = " " },
      }
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
        "neo-tree", "snacks_picker_list", "snacks_picker_input", "snacks_layout_box",
        "snacks_dashboard", "snacks_terminal", "Trouble", "trouble", "help", "qf",
        "lazy", "mason", "toggleterm", "TelescopePrompt", "oil",
      }
      opts.options.disabled_filetypes = df
    end,
  },
}
