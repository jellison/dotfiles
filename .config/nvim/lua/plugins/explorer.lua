return {
  -- Open the Snacks file explorer as a left sidebar on startup, without stealing
  -- focus from the editor (Zed-style). Registered in `init` (runs early, before
  -- VimEnter) so it reliably fires for both:
  --   * `nvim <file>`                (caught by VimEnter)
  --   * `nvim` -> dashboard -> file  (caught by BufWinEnter)
  {
    "folke/snacks.nvim",
    init = function()
      local group = vim.api.nvim_create_augroup("open_explorer_on_start", { clear = true })
      local opened = false
      local function open_explorer()
        if opened then
          return
        end
        local buf = vim.api.nvim_get_current_buf()
        -- Only for normal, named file buffers (skip dashboard, pickers, pagers).
        if vim.bo[buf].buftype ~= "" or vim.api.nvim_buf_get_name(buf) == "" then
          return
        end
        opened = true
        vim.schedule(function()
          pcall(function()
            Snacks.explorer.open({ enter = false })
          end)
        end)
      end
      vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter" }, {
        group = group,
        callback = open_explorer,
      })
    end,
  },
}
