-- lualine theme for the OpenCode Material Dark colorscheme.
--
-- Counterpart to opencode-material-light.lua; see that file for why these exist
-- at all (lualine's `auto` theme mis-derives both a mode accent and the bar
-- background from this palette). Same flat construction: one surface for every
-- section, colour only on the mode name.
--
-- Ratios are measured against the surface. The palette's accents are bright
-- enough to read as text on a dark surface, so they are used unmodified; only
-- the quiet text colour needed picking, since the dark palette's own `muted`
-- (#546e7a) is 2.81:1 here.

local c = {
  surface = "#1e272c", -- bg_dark: panels, floats, statusline
  fg      = "#eeffff", -- 14.75:1
  quiet   = "#90a4ae", --  5.87:1
  faded   = "#708b9c", --  4.24:1 -- inactive windows only, dim on purpose

  blue    = "#82aaff", --  6.62:1 -- normal
  green   = "#c3e88d", -- 11.03:1 -- insert
  purple  = "#c792ea", --  6.32:1 -- visual
  red     = "#f07178", --  5.31:1 -- replace
  yellow  = "#ffcb6b", -- 10.14:1 -- command
  cyan    = "#89ddff", -- 10.02:1 -- terminal
}

-- One surface everywhere, so lualine's section separators land fg-on-identical-bg
-- and simply disappear. Give section a/b a different bg to bring them back.
local function mode(accent)
  return {
    a = { fg = accent, bg = c.surface, gui = "bold" },
    b = { fg = c.fg, bg = c.surface },
    c = { fg = c.quiet, bg = c.surface },
  }
end

local theme = {
  normal = mode(c.blue),
  insert = mode(c.green),
  visual = mode(c.purple),
  replace = mode(c.red),
  command = mode(c.yellow),
  terminal = mode(c.cyan),
  inactive = {
    a = { fg = c.faded, bg = c.surface, gui = "bold" },
    b = { fg = c.faded, bg = c.surface },
    c = { fg = c.faded, bg = c.surface },
  },
}

return theme
