return {
  -- Don't auto-render markdown in the buffer; start in raw mode.
  -- Toggle rendering on/off with <leader>um. When on, aim for an Obsidian-like
  -- read: colored bold headings (no full-width bars), padded code blocks, clean
  -- bullets/links. Colors come from the active OpenCode Material palette
  -- (RenderMarkdown* groups in colors/opencode-material-{dark,light}.lua), so it
  -- follows system light/dark. (Terminal can't do variable font sizes — use
  -- <leader>cp for a true browser render.)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      enabled = false,
      heading = {
        position = "overlay", -- icon replaces the ### markers
        sign = false, -- no sign-column glyph
        width = "block",
        border = false,
        left_pad = 0,
        right_pad = 0,
      },
      code = {
        sign = false,
        width = "block", -- block sits behind the content, not full width
        border = "hide", -- hide the ``` fences (no heavy border line)
        left_pad = 2,
        right_pad = 2,
        language_name = true,
      },
      bullet = {
        icons = { "•", "◦", "▪", "▫" },
      },
      dash = { icon = "─" },
    },
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
