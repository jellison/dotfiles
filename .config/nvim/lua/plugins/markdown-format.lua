-- Markdown formatting: clean slate.
--
-- We deliberately DON'T run deno fmt (or prettier) on markdown. Those are
-- all-or-nothing formatters that rewrite everything — tables, lists, links,
-- headings, prose. We only want prose hard-wrapping, which nvim does natively
-- via `textwidth` (see after/ftplugin/markdown.lua). So: no format-on-save
-- formatter for markdown, and nothing but our own prose wrap is applied.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.markdown = {} -- was { "deno_fmt" }
      opts.formatters_by_ft["markdown.mdx"] = {}
    end,
  },
}
