-- Never format-on-save Markdown, not even via the LSP fallback. See
-- lua/plugins/markdown-format.lua for why.
vim.b.autoformat = false

-- Soft wrap instead: display long lines wrapped at word boundaries, with
-- continuation lines keeping the list/quote indent. The file is untouched.
-- Cap the visible width with zen mode (<leader>uz), configured to 80 columns
-- in lua/plugins/zen.lua.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.showbreak = ""
