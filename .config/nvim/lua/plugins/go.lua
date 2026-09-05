-- Go tooling fixes.
-- Your machine has mismatched Go toolchains (brew go 1.26.5 vs GOROOT 1.25.7),
-- so Mason's "go install" builds of gopls/goimports/gofumpt fail. We already
-- have working copies on PATH, so bypass Mason for these and use the system ones.
return {
  -- Use the gopls that's already on PATH instead of a Mason-built one.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          mason = false,
          settings = {
            gopls = {
              analyses = {
                -- ST1000 (missing package comment): matches golangci-lint,
                -- which also excludes it by default.
                ST1000 = false,
              },
            },
          },
        },
      },
    },
  },

  -- Don't let Mason try to (re)build these from source; conform/nvim-lint
  -- will use the copies already on PATH (goimports, gofumpt, golangci-lint).
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return not vim.tbl_contains({ "gopls", "goimports", "gofumpt" }, tool)
      end, opts.ensure_installed or {})
    end,
  },
}
