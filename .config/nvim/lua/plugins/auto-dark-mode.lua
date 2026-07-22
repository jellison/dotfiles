-- Follow the macOS system appearance: switch between the light and dark
-- OpenCode Material colorschemes automatically when you toggle light/dark mode.
return {
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      update_interval = 3000, -- ms; polls the system appearance
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("opencode-material-dark")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("opencode-material-light")
      end,
    },
  },
}
