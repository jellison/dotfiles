-- Zen mode (<leader>uz) centers the buffer in a fixed-width window. With soft
-- wrap on in Markdown (after/ftplugin/markdown.lua) this reads like an
-- 80-column hard wrap without rewriting the file.
return {
  {
    "folke/snacks.nvim",
    opts = {
      zen = {
        win = { width = 80 },
      },
    },
  },
}
