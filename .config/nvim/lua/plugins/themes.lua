-- Themes. You're a theme bitch, so here's a curated pantry.
-- Switch live with `<leader>uC` (fuzzy colorscheme picker) or `:colorscheme <Tab>`.
-- To make one the permanent default, change `colorscheme` at the bottom.
return {
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 }, -- latte/frappe/macchiato/mocha
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },                 -- storm/night/moon/day
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },                 -- wave/dragon/lotus
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },  -- main/moon/dawn
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
  { "sainnhe/everforest", lazy = false, priority = 1000 },
  { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },                -- nightfox/duskfox/carbonfox
  {
    "pjhamera/national-parks-themes",
    lazy = false,
    priority = 1000,
    config = function()
      require("parks").setup()
    end,
  },

  -- Active theme. Change this string, save, restart -> new default.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "opencode-material-dark",
    },
  },
}
