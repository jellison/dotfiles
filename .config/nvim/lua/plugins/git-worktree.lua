-- Switch between git worktrees without leaving nvim (<leader>gw).
-- Lists `git worktree list`, and on select changes nvim's cwd to that worktree
-- and opens its file finder. Creation/deletion is left to git/lazygit.

local function get_worktrees()
  local out = vim.fn.systemlist({ "git", "worktree", "list", "--porcelain" })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local items, cur = {}, nil
  for _, line in ipairs(out) do
    if line:match("^worktree ") then
      cur = { path = line:sub(10) }
    elseif cur and line:match("^branch ") then
      cur.branch = line:gsub("^branch refs/heads/", "")
    elseif cur and line == "detached" then
      cur.branch = "(detached)"
    elseif cur and line:match("^bare") then
      cur.branch = "(bare)"
    elseif line == "" and cur then
      items[#items + 1] = cur
      cur = nil
    end
  end
  if cur then
    items[#items + 1] = cur
  end
  return items
end

local function switch_worktree()
  local items = get_worktrees()
  if not items then
    Snacks.notify.warn("Not in a git repository")
    return
  end
  if #items == 0 then
    Snacks.notify.warn("No git worktrees found")
    return
  end
  local cwd = vim.fn.getcwd()
  vim.ui.select(items, {
    prompt = "Git worktree",
    format_item = function(item)
      local here = vim.startswith(cwd, item.path) and "● " or "  "
      return here .. (item.branch or "?") .. "   " .. vim.fn.fnamemodify(item.path, ":~")
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd.cd(vim.fn.fnameescape(choice.path))
    Snacks.notify("Worktree: " .. (choice.branch or "") .. "  (" .. vim.fn.fnamemodify(choice.path, ":~") .. ")")
    Snacks.picker.files({ cwd = choice.path })
  end)
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gw", switch_worktree, desc = "Switch git worktree" },
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
