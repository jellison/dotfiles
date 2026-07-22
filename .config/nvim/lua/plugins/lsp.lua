-- Disable LSP inlay hints by default (toggle per-session with <leader>uh).
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
}
