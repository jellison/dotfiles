-- Use Deno as the single Markdown formatter. It consistently wraps prose,
-- including list items and block quotes, at its default 80-column width.
-- Formatting runs through LazyVim's normal manual and format-on-save paths.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.markdown = { "deno_fmt" }
      opts.formatters_by_ft["markdown.mdx"] = { "deno_fmt" }
    end,
  },
}
