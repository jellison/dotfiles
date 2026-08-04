-- Edit the Obsidian vault (~/Notes) from Neovim while staying fully compatible
-- with Obsidian itself:
--   * daily notes in _Daily/YYYY-MM-DD.md
--   * images pasted to _Attachments/ as ![[wiki]] embeds (Obsidian's format)
--   * wikilink navigation, backlinks, search, quick-switch
-- Rendering is left to render-markdown (ui disabled here to avoid a double UI).
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        { name = "notes", path = "~/Notes" },
      },
      daily_notes = {
        folder = "_Daily",
        date_format = "YYYY-MM-DD", -- matches existing 2026-07-31.md files
      },
      attachments = {
        folder = "_Attachments", -- same folder Obsidian saves images to
        -- img_name_func default = "Pasted image <timestamp>" (matches Obsidian)
        -- img_text_func default respects link.style below -> ![[name.png]]
      },
      -- link.style defaults to "wiki" (![[...]]) which matches the vault; keep it.
      link = { style = "wiki" },
      -- Don't inject/manage YAML frontmatter in notes (leave files as-is).
      frontmatter = { enabled = false },
      -- Let render-markdown own the in-buffer rendering (no competing UI/conceal).
      ui = { enable = false },
      picker = { name = "snacks.picker" },
      -- Only the new `:Obsidian <subcmd>` syntax (silences the 4.0 deprecation warning).
      legacy_commands = false,
    },
    keys = {
      { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily note (today)" },
      { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Daily note (yesterday)" },
      { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image" },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch note" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes (grep)" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Links in note" },
    },
  },

  -- which-key group label for the notes/obsidian menu.
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>o", group = "obsidian", icon = "󰠮" })
    end,
  },
}
