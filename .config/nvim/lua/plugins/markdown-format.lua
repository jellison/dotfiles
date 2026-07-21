-- Format-on-save for Markdown.
-- LazyVim already enables autoformat globally (vim.g.autoformat = true);
-- this just tells conform WHICH formatter to run for markdown files.
--
-- Using `deno fmt` (already on your PATH, zero extra installs).
-- Prefer prettier instead? See the note at the bottom.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Force markdown to use ONLY deno_fmt. The markdown extra tries to add
      -- prettier/markdownlint-cli2/markdown-toc; assigning here replaces that
      -- list so we don't run (possibly missing) formatters on save.
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.markdown = { "deno_fmt" }
      opts.formatters_by_ft["markdown.mdx"] = { "deno_fmt" }
    end,
  },
}

-- To match Zed's prettier behavior exactly instead:
--   1) install it once:  npm i -g prettier
--   2) change the two lines above to:  { "prettier" }
