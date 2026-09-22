-- Follow the macOS system appearance: switch between the light and dark
-- OpenCode Material colorschemes automatically when you toggle light/dark mode.
--
-- Claude Code gets dragged along too. It has no "follow the terminal" theme,
-- and it never asks the terminal which appearance it is (it sends neither an
-- OSC 11 background query nor a DSR 996 colour-scheme query -- it only enables
-- DEC mode 2031 and waits for a notification that nothing ever pushes). So it
-- reads `theme` from ~/.claude.json once at startup and otherwise sits on its
-- default, which is "dark". Left alone, a session started in light mode paints
-- dark boxes -- the user-message background, the context meter -- into an
-- otherwise light UI, because most of its text is emitted as the terminal's
-- default foreground while those elements carry explicit dark-theme colours.
local claude_config = vim.fn.expand("~/.claude.json")

-- Patch the top-level `theme` key in place. That file is Claude Code's own
-- 90 KB state blob, so this rewrites the single key textually and validates the
-- result, rather than decoding and re-encoding the JSON (which would reorder
-- every key and collapse empty arrays into empty objects).
local function sync_claude_theme(theme)
  local file = io.open(claude_config, "r")
  if not file then
    return -- Claude Code has never run on this machine.
  end
  local contents = file:read("*a")
  file:close()

  local current = contents:match('\n  "theme": "([%w%-]+)"')
  if current == theme then
    return
  end

  local patched, replacements
  if current then
    patched, replacements =
      contents:gsub('\n  "theme": "[%w%-]+"', '\n  "theme": "' .. theme .. '"', 1)
  else
    patched, replacements = contents:gsub("^{\n", '{\n  "theme": "' .. theme .. '",\n', 1)
  end

  if replacements ~= 1 or not pcall(vim.json.decode, patched) then
    vim.notify("auto-dark-mode: could not set the Claude Code theme to " .. theme, vim.log.levels.WARN)
    return
  end

  -- Write a sibling temp file and rename, so a concurrent Claude Code read
  -- never observes a half-written config. Claude Code owns this file and may
  -- still overwrite the key from its own in-memory copy; the next appearance
  -- change (or the next nvim start) puts it back.
  local tmp = claude_config .. ".nvim-theme.tmp"
  local out = io.open(tmp, "w")
  if not out then
    vim.notify("auto-dark-mode: could not write " .. tmp, vim.log.levels.WARN)
    return
  end
  out:write(patched)
  out:close()

  local renamed, err = os.rename(tmp, claude_config)
  if not renamed then
    os.remove(tmp)
    vim.notify("auto-dark-mode: could not replace " .. claude_config .. ": " .. tostring(err), vim.log.levels.WARN)
  end
end

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
        sync_claude_theme("dark")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("opencode-material-light")
        sync_claude_theme("light")
      end,
    },
  },
}
