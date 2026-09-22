-- Multi-cursor editing via multicursor.nvim (jake-stewart), pinned to the
-- stable 1.0 branch. Native multi-cursor is slated for Neovim 0.13's "Batteries
-- Included" milestone; until that ships as a stable release this covers the same
-- ground on 0.12.x with a more mature feature set.
--
-- Add cursors:
--   ga{motion}   a cursor on each line the motion covers -> ga35j, gaip, gaG.
--                Also works on a visual selection (e.g. V35j then ga).
--   <A-Down>     add a cursor on the line below (repeat for a few lines)
--   <A-Up>       add a cursor on the line above
--   <C-n>        add a cursor at the next match of the word / visual selection
--
-- With cursors down: turn a bare list into a JSON-ish one -> ga35j, then
--   I"<Esc>  (prefix each line)  $  (jump every cursor to its line end)
--   A",<Esc> (append each)       <Esc> (clear the extra cursors)
-- Every normal-mode command (I, A, $, motions, operators) replays at each
-- cursor, so no extra mappings are needed for the editing itself.
--
-- <A-…> reaches Neovim because Ghostty sets `macos-option-as-alt = left`.
-- The plugin's mouse maps are intentionally left off so <C-LeftMouse> stays
-- bound to "open URL/file under cursor" in lua/config/keymaps.lua.

local function mc()
  return require("multicursor-nvim")
end

return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      { "ga", function() mc().addCursorOperator() end, mode = { "n", "x" }, desc = "Add cursors over motion (multicursor)" },
      { "<A-Down>", function() mc().lineAddCursor(1) end, mode = { "n", "x" }, desc = "Add cursor below (multicursor)" },
      { "<A-Up>", function() mc().lineAddCursor(-1) end, mode = { "n", "x" }, desc = "Add cursor above (multicursor)" },
      { "<C-n>", function() mc().matchAddCursor(1) end, mode = { "n", "x" }, desc = "Add cursor at next match (multicursor)" },
    },
    config = function()
      local m = mc()
      m.setup()

      -- These maps are active only while multiple cursors exist. <Esc> clears
      -- the extra cursors (first re-enabling them if they were toggled off).
      m.addKeymapLayer(function(layerSet)
        layerSet("n", "<esc>", function()
          if not m.cursorsEnabled() then
            m.enableCursors()
          else
            m.clearCursors()
          end
        end)
      end)
    end,
  },
}
