-- Don't format Markdown at all. The LazyVim markdown extra registers prettier
-- and markdownlint-cli2 as formatters, which rewrap prose at a fixed width.
-- Collaborators don't share that setting, so it created churn in shared docs.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.markdown = {}
      opts.formatters_by_ft["markdown.mdx"] = {}
    end,
  },
}
