local M = {}

local cached_main_worktree

local function notify(message, level)
  if _G.Snacks and Snacks.notify then
    if level == vim.log.levels.WARN and Snacks.notify.warn then
      Snacks.notify.warn(message)
      return
    end
    if level == vim.log.levels.ERROR and Snacks.notify.error then
      Snacks.notify.error(message)
      return
    end
    Snacks.notify(message)
    return
  end
  vim.notify(message, level)
end

local function safe_getcwd()
  local ok, cwd = pcall(vim.fn.getcwd)
  if ok then
    return cwd
  end
  return nil
end

local function exists(path)
  return path and path ~= "" and vim.uv.fs_stat(path) ~= nil
end

local function cd(path)
  vim.cmd.cd(vim.fn.fnameescape(path))
end

function M.get_worktrees()
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

function M.main_worktree(items)
  items = items or M.get_worktrees()
  if not items or #items == 0 then
    return cached_main_worktree
  end

  for _, item in ipairs(items) do
    if item.branch == "main" or item.branch == "master" then
      cached_main_worktree = item.path
      return cached_main_worktree
    end
  end

  for _, item in ipairs(items) do
    if item.branch ~= "(bare)" then
      cached_main_worktree = item.path
      return cached_main_worktree
    end
  end

  return cached_main_worktree
end

function M.switch_to_main_worktree(path)
  local main = path or M.main_worktree()
  if not exists(main) then
    notify("Main worktree is unavailable" .. (main and (": " .. main) or ""), vim.log.levels.ERROR)
    return false
  end

  cd(main)
  notify("Worktree: main  (" .. vim.fn.fnamemodify(main, ":~") .. ")")
  return true
end

function M.recover_deleted_cwd(path)
  local cwd = safe_getcwd()
  if exists(cwd) then
    return false
  end

  local main = path or cached_main_worktree or M.main_worktree()
  if exists(main) then
    cd(main)
    notify("cwd was deleted; switched to main worktree: " .. vim.fn.fnamemodify(main, ":~"), vim.log.levels.WARN)
    return true
  end

  notify("cwd was deleted and no main worktree is available", vim.log.levels.ERROR)
  return false
end

function M.switch_worktree()
  local items = M.get_worktrees()
  if not items then
    notify("Not in a git repository", vim.log.levels.WARN)
    return
  end
  if #items == 0 then
    notify("No git worktrees found", vim.log.levels.WARN)
    return
  end

  M.main_worktree(items)

  local cwd = safe_getcwd() or ""
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
    cd(choice.path)
    notify("Worktree: " .. (choice.branch or "") .. "  (" .. vim.fn.fnamemodify(choice.path, ":~") .. ")")
  end)
end

function M.setup_deleted_cwd_recovery()
  M.main_worktree()
  vim.api.nvim_create_user_command("GitWorktreeMain", function()
    M.switch_to_main_worktree()
  end, { desc = "Switch cwd to the main git worktree" })
  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("user_worktree_cwd_recovery", { clear = true }),
    callback = function()
      M.recover_deleted_cwd()
    end,
  })
end

return M
