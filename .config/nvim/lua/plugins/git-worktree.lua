-- Switch between git worktrees without leaving nvim (<leader>gw).
-- Lists `git worktree list`, and on select changes nvim's cwd to that worktree.
-- Creation/deletion is left to git/lazygit.

local worktree = require("config.worktree")

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gw", worktree.switch_worktree, desc = "Switch git worktree" },
      { "<leader>gW", worktree.switch_to_main_worktree, desc = "Switch to main worktree" },
      -- Open lazygit at the working directory (not the active buffer's worktree),
      -- so it follows `:cd` / the <leader>gw worktree switcher.
      {
        "<leader>gg",
        function()
          Snacks.lazygit({ cwd = vim.fn.getcwd() })
        end,
        desc = "Lazygit (cwd)",
      },
    },
  },
}
