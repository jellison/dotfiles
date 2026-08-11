-- Markdown formatting: wrap top-level prose without rewriting Markdown syntax.
--
-- Conform's Markdown formatters are all-or-nothing, so leave them disabled and
-- register our Tree-sitter-scoped formatter directly with LazyVim. It then
-- participates in the usual format command, format-on-save, and format toggles.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.markdown = {} -- was { "deno_fmt" }
      opts.formatters_by_ft["markdown.mdx"] = {}
    end,
  },
  {
    "LazyVim/LazyVim",
    init = function()
      LazyVim.on_very_lazy(function()
        LazyVim.format.register({
          name = "markdown-reflow",
          priority = 200,
          primary = true,
          format = function(buf)
            require("config.markdown_reflow").format(buf, 80)
          end,
          sources = function(buf)
            return vim.tbl_contains({ "markdown", "markdown.mdx" }, vim.bo[buf].filetype) and { "markdown-reflow" }
              or {}
          end,
        })
      end)
    end,
  },
}
