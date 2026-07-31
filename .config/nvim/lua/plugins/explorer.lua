return {
  -- Start nvim like Zed: file explorer on the left, a blank buffer on the right.
  -- No dashboard/intro screen. The explorer opens without stealing focus, so the
  -- cursor stays in the (empty) editor window.
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false }, -- no intro screen; land on a blank [No Name] buffer
    },
    init = function()
      local group = vim.api.nvim_create_augroup("open_explorer_on_start", { clear = true })
      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
          -- Skip special startup buffers (piped stdin, `-c` scratch, etc.).
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].buftype ~= "" then
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
}
