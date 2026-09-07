-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ── UUID / GUID ────────────────────────────────────────────────────────────
-- Generate & insert a random v4 UUID at the cursor. Pure Lua (no deps), so it
-- works on any machine.
--   <leader>ig / :UUID    formatted   -> 3f2504e0-4f89-41d3-9a0c-0305e82c3301
--   <leader>iG / :UUID!   unformatted -> 3f2504e04f8941d39a0c0305e82c3301
math.randomseed(tonumber(tostring(vim.uv.hrtime()):sub(-9)) or os.time())

local function gen_uuid(unformatted)
  local s = ("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", function(c)
    local v = (c == "x") and math.random(0, 15) or math.random(8, 11) -- v4 variant bits
    return string.format("%x", v)
  end)
  return unformatted and (s:gsub("-", "")) or s
end

local function insert_uuid(unformatted)
  vim.api.nvim_put({ gen_uuid(unformatted) }, "c", true, true) -- paste at cursor, move after
end

vim.api.nvim_create_user_command("UUID", function(opts)
  insert_uuid(opts.bang)
end, { bang = true, desc = "Insert a random v4 UUID (! = unformatted)" })

vim.keymap.set("n", "<leader>ig", function() insert_uuid(false) end, { desc = "Insert GUID (formatted)" })
vim.keymap.set("n", "<leader>iG", function() insert_uuid(true) end, { desc = "Insert GUID (unformatted)" })

-- ── Copy current file's path / name to the system clipboard ─────────────────
local function copy_path(mod, label)
  local path = vim.fn.expand("%" .. mod)
  if path == "" then
    vim.notify("No file name for this buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", path) -- system clipboard
  vim.notify(label .. ": " .. path)
end

vim.keymap.set("n", "<leader>fy", function() copy_path(":p", "Copied absolute path") end, { desc = "Copy absolute path" })
vim.keymap.set("n", "<leader>fY", function() copy_path(":.", "Copied relative path") end, { desc = "Copy relative path (cwd)" })
vim.keymap.set("n", "<leader>fN", function() copy_path(":t", "Copied filename") end, { desc = "Copy filename" })
vim.keymap.set("n", "<leader>fD", function() copy_path(":p:h", "Copied directory") end, { desc = "Copy directory path" })

-- ── Terminal: attach to a per-repo herdr session ────────────────────────────
-- <C-/> normally opens a plain shell at the project root. When the root is
-- anywhere under ~/code/<repo> (including nested worktrees), open herdr
-- attached to a persistent session named after <repo> instead. Snacks keys the
-- terminal by cmd + cwd, so the mapping still toggles the same window.
local code_dir = vim.fn.expand("~/code")

--- Extract the top-level repo name if `dir` is under ~/code/<repo>.
---@param dir string
---@return string?
local function herdr_session_for(dir)
  local rel = vim.fs.relpath(code_dir, dir)
  if not rel or rel == "." then
    return nil
  end
  return rel:match("^[^/]+")
end

local function repo_terminal()
  local root = LazyVim.root()
  local session = vim.fn.executable("herdr") == 1 and herdr_session_for(root) or nil
  local cmd = session and { "herdr", "--session", session } or nil
  Snacks.terminal.focus(cmd, { cwd = root })
end

vim.keymap.set({ "n", "t" }, "<c-/>", repo_terminal, { desc = "Terminal (Root Dir / herdr session)" })
vim.keymap.set({ "n", "t" }, "<c-_>", repo_terminal, { desc = "which_key_ignore" })

-- ── Lazygit → diff view ─────────────────────────────────────────────────────
-- Called by the lazygit <c-g> custom commands (see ~/.config/lazygit/config.yml)
-- via `nvim --server $NVIM --remote-send`. Hides the lazygit float, then:
--   :LazygitDiff <file>         vimdiff of the working file against the index
--   :LazygitDiff <rev> <file>   vimdiff of <file> at <rev> against its parent

--- Wait for gitsigns to finish attaching to `buf`. diffthis asserts on the
--- cached comparison text, which gitsigns fills in asynchronously.
---@param buf integer
---@return boolean
local function wait_for_gitsigns(buf)
  return vim.wait(3000, function()
    local entry = require("gitsigns.cache").cache[buf]
    return entry ~= nil and entry.compare_text ~= nil
  end, 50)
end

vim.api.nvim_create_user_command("LazygitDiff", function(opts)
  local args = opts.fargs
  local rev
  if #args >= 2 and args[1]:match("^%x+$") then
    rev = table.remove(args, 1)
  end
  local file = table.concat(args, " ")

  if vim.fn.isdirectory(file) == 1 then
    Snacks.notify.warn("Select a file, not a directory: " .. file)
    return
  end

  if vim.bo.buftype == "terminal" then
    vim.cmd.close()
  end

  vim.cmd.edit(vim.fn.fnameescape(file))
  local gs = require("gitsigns")
  if not wait_for_gitsigns(vim.api.nvim_get_current_buf()) then
    Snacks.notify.warn("gitsigns did not attach to " .. file)
    return
  end
  if not rev then
    gs.diffthis()
    return
  end

  -- Replace the working file with its contents at <rev> (a gitsigns://
  -- buffer), then diff that against the parent commit.
  gs.show(rev, function(err)
    if err then
      Snacks.notify.error(err)
      return
    end
    if not wait_for_gitsigns(vim.api.nvim_get_current_buf()) then
      Snacks.notify.warn("gitsigns did not attach to " .. file .. " @ " .. rev)
      return
    end
    gs.diffthis(rev .. "~")
  end)
end, { nargs = "+", complete = "file", desc = "Open file in diff mode (from lazygit)" })
