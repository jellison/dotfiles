return {
  -- Make the built-in shell terminal (<C-/>, <leader>ft/fT) open as a large
  -- centered float like the lazygit window, instead of a bottom split.
  -- Handy for full-screen agent/CLI interaction.
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          position = "float",
          width = 0.9,
          height = 0.9,
          border = "rounded",
        },
      },
    },
  },
}
