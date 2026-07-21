return {
  {
    "folke/snacks.nvim",
    -- Project-scoped recent files:
    --   <leader>fr -> recent files under the current project (cwd)
    --   <leader>fR -> recent files everywhere (the old global behavior)
    keys = {
      {
        "<leader>fr",
        function()
          Snacks.picker.recent({ filter = { cwd = true } })
        end,
        desc = "Recent (project)",
      },
      {
        "<leader>fR",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent (all)",
      },
    },
    -- Make the dashboard's `r` (Recent Files) project-scoped too.
    opts = function(_, opts)
      local keys = vim.tbl_get(opts, "dashboard", "preset", "keys")
      if keys then
        for _, item in ipairs(keys) do
          if item.key == "r" then
            item.desc = "Recent Files (project)"
            item.action = ":lua Snacks.picker.recent({ filter = { cwd = true } })"
          end
        end
      end
    end,
  },
}
