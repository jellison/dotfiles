-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use absolute line numbers instead of LazyVim's default relative numbers.
vim.opt.relativenumber = false

-- Ensure common tool dirs are on PATH regardless of how nvim is launched
-- (fixes Snacks not finding `fd`, and finds `gopls`/formatters in ~/go/bin).
for _, p in ipairs({ "/opt/homebrew/bin", vim.fn.expand("~/go/bin") }) do
  if vim.fn.isdirectory(p) == 1 and not (":" .. vim.env.PATH .. ":"):find(":" .. p .. ":", 1, true) then
    vim.env.PATH = p .. ":" .. vim.env.PATH
  end
end
