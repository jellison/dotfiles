-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Hybrid line numbers (absolute current line, relative elsewhere).
vim.opt.relativenumber = true

-- Disable concealing (show raw text: markdown syntax, quotes in JSON, etc.).
vim.opt.conceallevel = 0

-- Workspace/root = the current working directory, always. Opening a file
-- (including a symlink that points into another repo) never changes the root;
-- change it explicitly with :cd or <leader>gw. Overrides LazyVim's default
-- { "lsp", { ".git", "lua" }, "cwd" } which followed symlinks to their target repo.
vim.g.root_spec = { "cwd" }

-- Ensure common tool dirs are on PATH regardless of how nvim is launched
-- (fixes Snacks not finding `fd`, and finds `gopls`/formatters in ~/go/bin).
for _, p in ipairs({ "/opt/homebrew/bin", vim.fn.expand("~/go/bin") }) do
  if vim.fn.isdirectory(p) == 1 and not (":" .. vim.env.PATH .. ":"):find(":" .. p .. ":", 1, true) then
    vim.env.PATH = p .. ":" .. vim.env.PATH
  end
end
