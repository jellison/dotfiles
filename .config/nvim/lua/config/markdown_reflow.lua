local M = {}

local namespace = vim.api.nvim_create_namespace("markdown_reflow")

local function set_auto_wrap(buf, enabled)
  local formatoptions = vim.bo[buf].formatoptions:gsub("[cl]", "")
  formatoptions = formatoptions:gsub("t", "")
  vim.bo[buf].formatoptions = enabled and (formatoptions .. "t") or formatoptions
end

local function is_top_level_paragraph(node)
  local parent = node:parent()

  -- Tree-sitter nests ordinary document prose in zero or more `section`
  -- nodes. Any other ancestor means the paragraph belongs to a structure we
  -- intentionally preserve, such as a list item or block quote.
  while parent do
    local kind = parent:type()
    if kind == "document" then
      return true
    end
    if kind ~= "section" then
      return false
    end
    parent = parent:parent()
  end

  return false
end

local function paragraph_ranges(buf, width)
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if not ok or not parser then
    return {}
  end

  local tree = parser:parse()[1]
  if not tree then
    return {}
  end

  local ranges = {}

  local function walk(node)
    if node:type() == "paragraph" and is_top_level_paragraph(node) then
      local start_row, _, end_row, end_col = node:range()
      local start_line = start_row + 1
      local end_line = end_row + (end_col > 0 and 1 or 0)
      local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

      if vim.iter(lines):any(function(line)
        return vim.fn.strdisplaywidth(line) > width
      end) then
        ranges[#ranges + 1] = { start_line, end_line }
      end
    end

    for child in node:iter_children() do
      walk(child)
    end
  end

  walk(tree:root())
  return ranges
end

local function cursor_is_top_level_prose(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if not ok or not parser then
    return true
  end

  local tree = parser:parse()[1]
  local row = cursor[1] - 1
  local col = math.max(cursor[2] - 1, 0)
  local node = tree and tree:root():named_descendant_for_range(row, col, row, col) or nil
  if not node then
    return true
  end

  local current = node
  while current do
    if current:type() == "paragraph" then
      return is_top_level_paragraph(current)
    end
    current = current:parent()
  end

  -- A blank top-level line resolves directly to its section/document. Enable
  -- wrapping there so a newly typed paragraph hard-wraps normally.
  return node:type() == "section" or node:type() == "document"
end

local function reflow_range(start_line, end_line)
  vim.api.nvim_win_set_cursor(0, { start_line, 0 })

  local line_count = end_line - start_line + 1
  if line_count == 1 then
    vim.cmd.normal({ "gqq", bang = true })
  else
    vim.cmd.normal({ "gq" .. (line_count - 1) .. "j", bang = true })
  end
end

function M.format(buf, width)
  buf = buf or vim.api.nvim_get_current_buf()
  width = width or 80

  if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].modifiable then
    return
  end

  local ranges = paragraph_ranges(buf, width)
  if #ranges == 0 then
    return
  end

  vim.api.nvim_buf_call(buf, function()
    local view = vim.fn.winsaveview()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_mark = vim.api.nvim_buf_set_extmark(buf, namespace, cursor[1] - 1, cursor[2], {
      right_gravity = false,
    })
    local formatexpr = vim.bo[buf].formatexpr
    local formatprg = vim.bo[buf].formatprg

    -- Force gq to use Neovim's built-in text formatter. LazyVim normally sets
    -- formatexpr to its LSP/Conform dispatcher, which is deliberately disabled
    -- for Markdown but should not participate here even if that changes later.
    vim.bo[buf].formatexpr = ""
    vim.bo[buf].formatprg = ""

    local ok, err = xpcall(function()
      -- Work upward so line-count changes do not invalidate unformatted ranges.
      for index = #ranges, 1, -1 do
        if index < #ranges then
          pcall(vim.cmd, "undojoin")
        end
        reflow_range(ranges[index][1], ranges[index][2])
      end
    end, debug.traceback)

    vim.bo[buf].formatexpr = formatexpr
    vim.bo[buf].formatprg = formatprg

    local mark = vim.api.nvim_buf_get_extmark_by_id(buf, namespace, cursor_mark, {})
    vim.api.nvim_buf_del_extmark(buf, namespace, cursor_mark)
    if #mark == 2 then
      view.lnum = mark[1] + 1
      view.col = mark[2]
    end
    vim.fn.winrestview(view)

    if not ok then
      error(err)
    end
  end)
end

function M.setup_live_wrap(buf, width)
  buf = buf or vim.api.nvim_get_current_buf()
  width = width or 80

  vim.bo[buf].textwidth = width
  set_auto_wrap(buf, true)

  local group = vim.api.nvim_create_augroup("user_markdown_live_wrap", { clear = false })
  vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
  vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
    group = group,
    buffer = buf,
    callback = function()
      set_auto_wrap(buf, cursor_is_top_level_prose(buf))
    end,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    buffer = buf,
    callback = function()
      set_auto_wrap(buf, true)
    end,
  })
end

return M
