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
