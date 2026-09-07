-- Full-screen float used for the shell terminal and lazygit. Only the
-- statusline and cmdline stay visible.
local fullscreen = {
  position = "float",
  width = 0, -- 0 = full editor width
  -- Everything except the statusline and the cmdline.
  height = function()
    local status = vim.o.laststatus > 0 and 1 or 0
    return vim.o.lines - vim.o.cmdheight - status
  end,
  row = 0,
  col = 0,
  border = "none",
}

return {
  -- Make the built-in shell terminal (<C-/>, <leader>ft/fT) and lazygit
  -- (<leader>gg) open full screen instead of a bottom split / centered float.
  -- Handy for full-screen agent/CLI interaction.
  {
    "folke/snacks.nvim",
    opts = {
      terminal = { win = fullscreen },
      lazygit = { win = fullscreen },
    },
  },
}
