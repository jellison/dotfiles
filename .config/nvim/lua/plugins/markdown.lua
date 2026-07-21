return {
  -- Don't auto-render markdown in the buffer; start in raw mode.
  -- Toggle rendering on/off with <leader>um.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { enabled = false },
  },

  -- The markdown extra wires up markdownlint-cli2 as a linter, but it's not
  -- installed (and prose linting is noisy for notes). Disable it so opening a
  -- markdown file doesn't error.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      if opts.linters_by_ft then
        opts.linters_by_ft["markdown"] = {}
        opts.linters_by_ft["markdown.mdx"] = {}
      end
    end,
  },

  -- Don't let Mason try to install the (now-unused) markdown linter.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "markdownlint-cli2"
      end, opts.ensure_installed or {})
    end,
  },
}
