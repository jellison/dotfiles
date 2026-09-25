-- LeetCode inside nvim. Start it either way:
--   `nvim leetcode.nvim`  dedicated session; `:Leet exit` quits nvim.
--   `:Leet`               from any session; opens in a new tab, and `:Leet exit`
--                         closes it and restores the previous cwd.
-- The first run asks for the Cookie request header from a logged-in
-- leetcode.com browser session. Solutions live under stdpath("data")/leetcode.
-- Switch language per problem with :Leet lang. The html treesitter parser it
-- needs ships with LazyVim's defaults, so the upstream
-- `build = ":TSUpdate html"` step is omitted.
local leet_arg = "leetcode.nvim"

return {
  {
    "kawre/leetcode.nvim",
    -- Load at startup only for the dedicated session, where the plugin hooks
    -- VimEnter; otherwise wait for :Leet.
    lazy = vim.fn.argv(0, -1) ~= leet_arg,
    cmd = "Leet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      arg = leet_arg,
      lang = "golang",
      -- Allow :Leet in a session that already has files open.
      plugins = { non_standalone = true },
    },
  },
}
