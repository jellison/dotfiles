return {
  -- Startup layout (Zed-style): restore this workspace's session, then show the
  -- file explorer on the left. No dashboard.
  --
  -- Sessions are managed by persistence.nvim, keyed by cwd (and git branch), so
  -- restore is scoped per workspace: `nvim` in ~/code/humiomanager restores that
  -- project's buffers/windows, not ~/code/humio's. Restore only happens on a bare
  -- `nvim` (no file args / no stdin); `nvim <file>` just opens that file.
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false }, -- no intro screen
    },
    init = function()
      local group = vim.api.nvim_create_augroup("start_layout", { clear = true })

      -- Detect `… | nvim -` so we don't clobber piped input with a session.
      vim.api.nvim_create_autocmd("StdinReadPre", {
        group = group,
        callback = function()
          vim.g._started_with_stdin = true
        end,
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        nested = true, -- let restored buffers trigger their file autocmds (LSP, etc.)
        callback = function()
          -- Restore the cwd's session on a bare launch.
          if vim.fn.argc() == 0 and not vim.g._started_with_stdin then
            require("lazy").load({ plugins = { "persistence.nvim" } }) -- ensure it's set up
            pcall(function()
              require("persistence").load()
            end)
          end
          -- Open the explorer beside whatever we ended up with (restored or blank),
          -- without stealing focus. Skip special / git-editor buffers.
          local buf = vim.api.nvim_get_current_buf()
          local ft = vim.bo[buf].filetype
          if vim.bo[buf].buftype ~= "" or ft == "gitcommit" or ft == "gitrebase" then
            return
          end
          vim.schedule(function()
            pcall(function()
              Snacks.explorer.open({ enter = false })
            end)
          end)
        end,
      })
    end,
  },

  -- Don't serialize the explorer (or any Snacks picker) into the session — close
  -- them right before persistence writes it. The startup handler reopens the
  -- explorer, so it always comes back fresh.
  {
    "folke/persistence.nvim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceSavePre",
        group = vim.api.nvim_create_augroup("persistence_no_explorer", { clear = true }),
        callback = function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local b = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[b].filetype
            if type(ft) == "string" and ft:find("^snacks") then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end
        end,
      })
    end,
  },
}
