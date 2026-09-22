-- lualine theme for the OpenCode Material Light colorscheme.
--
-- lualine's `auto` theme loads `lua/lualine/themes/<colors_name>.lua` from the
-- user config in preference to anything it generates, so this file takes effect
-- just by existing -- there is no lualine option to change, and switching
-- colorschemes switches statusline themes with it.
--
-- Without it, `auto` guesses badly here: it takes Identifier's fg as the
-- command/terminal accent (plain text #263238 in this theme, hence a near-black
-- TERMINAL block with pale text) and darkens every colour it extracts by 10%,
-- so the bar ended up darker than the #f0f0f1 panels sitting above it.
--
-- Flat by design: every section shares the panel surface and only the mode name
-- carries colour. Because the accent is text rather than a filled block it has
-- to be legible on a light surface, and the palette's own accents are not
-- (green #91b859 is 2.00:1), so each is darkened until it clears WCAG AA.
-- Ratios below are measured against the surface.

local c = {
  surface = "#f0f0f1", -- bg_dark: panels, floats, statusline
  fg      = "#263238", -- 11.56:1
  quiet   = "#546e7a", --  4.74:1
  faded   = "#78909c", --  2.94:1 -- inactive windows only, dim on purpose

  blue    = "#4a6da7", --  4.57:1 -- normal
  green   = "#55712a", --  4.88:1 -- insert
  purple  = "#6a3fd0", --  5.70:1 -- visual
  red     = "#c62828", --  4.94:1 -- replace
  yellow  = "#7d6200", --  5.10:1 -- command
  cyan    = "#00707a", --  5.12:1 -- terminal
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
