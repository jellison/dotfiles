-- OpenCode Material Light
-- Ported from the Zed theme (~/.config/zed/themes/opencode-material.json).
-- Selectable via `:colorscheme opencode-material-light` or the `<leader>uC` picker.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "opencode-material-light"

-- Palette -------------------------------------------------------------------
local c = {
  bg          = "#fafafa", -- editor.background
  bg_dark     = "#f0f0f1", -- panels / floats / sidebars (surface)
  bg_elem     = "#e7e7e8", -- element.background / borders
  bg_line     = "#eef1f3", -- active line
  bg_sel      = "#d4dce9", -- visual selection (blue tint over bg)
  bg_pick_sel = "#ccd6e6", -- picker/explorer selected row (readable blue)
  dim         = "#aab7bd", -- ignored/hidden files (dimmed but still readable)
  bg_ref      = "#e8ebf2", -- lsp document highlight (blue tint over bg)
  bg_search   = "#fbe8bb", -- search match (yellow tint)

  fg          = "#263238", -- text
  fg_bright   = "#000000",
  muted       = "#90a4ae", -- text.muted / comments / line numbers
  invisible   = "#cfd8dc", -- invisibles / indent guides

  blue        = "#6182b8", -- accent, functions, info
  red         = "#e53935", -- errors, properties, tags
  green       = "#91b859", -- strings, added
  yellow      = "#b58900", -- types, warnings, modified (darkened for contrast on light bg)
  orange      = "#f4511e", -- numbers, constants, booleans
  purple      = "#7c4dff", -- keywords, attributes
  cyan        = "#39adb5", -- operators, punctuation

  -- diagnostic / diff background tints (light)
  err_bg      = "#fbe3e2",
  warn_bg     = "#faf1dc",
  info_bg     = "#e6ecf5",
  hint_bg     = "#e3f1f2",
  add_bg      = "#eaf0e2",
  del_bg      = "#fbe3e2",
  text_bg     = "#faf1dc",
  none        = "NONE",
}

local hl = function(group, spec) vim.api.nvim_set_hl(0, group, spec) end

local groups = {
  -- Editor UI ---------------------------------------------------------------
  Normal            = { fg = c.fg, bg = c.bg },
  NormalNC          = { fg = c.fg, bg = c.bg },
  NormalFloat       = { fg = c.fg, bg = c.bg_dark },
  FloatBorder       = { fg = c.bg_elem, bg = c.bg_dark },
  FloatTitle        = { fg = c.blue, bg = c.bg_dark, bold = true },
  ColorColumn       = { bg = c.bg_line },
  CursorLine        = { bg = c.bg_line },
  CursorColumn      = { bg = c.bg_line },
  CursorLineNr      = { fg = c.fg, bold = true },
  LineNr            = { fg = c.muted },
  SignColumn        = { bg = c.bg },
  FoldColumn        = { fg = c.muted, bg = c.bg },
  Folded            = { fg = c.muted, bg = c.bg_dark },
  Cursor            = { fg = c.bg, bg = c.yellow },
  TermCursor        = { fg = c.bg, bg = c.yellow },
  Visual            = { bg = c.bg_sel },
  VisualNOS         = { bg = c.bg_sel },
  Search            = { fg = c.fg, bg = c.bg_search },
  IncSearch         = { fg = c.bg, bg = c.yellow },
  CurSearch         = { fg = c.bg, bg = c.yellow },
  MatchParen        = { fg = c.yellow, bg = c.bg_elem, bold = true },
  NonText           = { fg = c.invisible },
  Whitespace        = { fg = c.invisible },
  SpecialKey        = { fg = c.invisible },
  Conceal           = { fg = c.muted },
  Directory         = { fg = c.blue },
  Title             = { fg = c.blue, bold = true },
  WinSeparator      = { fg = c.bg_elem },
  VertSplit         = { fg = c.bg_elem },
  EndOfBuffer       = { fg = c.bg },
  WildMenu          = { fg = c.bg, bg = c.blue },

  -- Popup menu / statusline / tabs -----------------------------------------
  Pmenu             = { fg = c.fg, bg = c.bg_dark },
  PmenuSel          = { fg = c.fg, bg = c.bg_elem },
  PmenuSbar         = { bg = c.bg_dark },
  PmenuThumb        = { bg = c.muted },
  StatusLine        = { fg = c.fg, bg = c.bg_dark },
  StatusLineNC      = { fg = c.muted, bg = c.bg_dark },
  TabLine           = { fg = c.muted, bg = c.bg_dark },
  TabLineFill       = { bg = c.bg_dark },
  TabLineSel        = { fg = c.fg, bg = c.bg },

  -- Messages ----------------------------------------------------------------
  ErrorMsg          = { fg = c.red },
  WarningMsg        = { fg = c.yellow },
  ModeMsg           = { fg = c.fg },
  MoreMsg           = { fg = c.blue },
  Question          = { fg = c.green },

  -- LSP reference highlights ------------------------------------------------
  LspReferenceText  = { bg = c.bg_ref },
  LspReferenceRead  = { bg = c.bg_ref },
  LspReferenceWrite = { bg = c.bg_ref },
  LspInlayHint      = { fg = c.muted, bg = c.bg_line, italic = true },

  -- Diagnostics -------------------------------------------------------------
  DiagnosticError            = { fg = c.red },
  DiagnosticWarn             = { fg = c.yellow },
  DiagnosticInfo             = { fg = c.blue },
  DiagnosticHint             = { fg = c.muted },
  DiagnosticOk               = { fg = c.green },
  DiagnosticVirtualTextError = { fg = c.red, bg = c.err_bg },
  DiagnosticVirtualTextWarn  = { fg = c.yellow, bg = c.warn_bg },
  DiagnosticVirtualTextInfo  = { fg = c.blue, bg = c.info_bg },
  DiagnosticVirtualTextHint  = { fg = c.muted, bg = c.hint_bg },
  DiagnosticUnderlineError   = { undercurl = true, sp = c.red },
  DiagnosticUnderlineWarn    = { undercurl = true, sp = c.yellow },
  DiagnosticUnderlineInfo    = { undercurl = true, sp = c.blue },
  DiagnosticUnderlineHint    = { undercurl = true, sp = c.muted },

  -- Diff / git --------------------------------------------------------------
  DiffAdd           = { bg = c.add_bg },
  DiffChange        = { bg = c.warn_bg },
  DiffDelete        = { fg = c.red, bg = c.del_bg },
  DiffText          = { bg = c.text_bg },
  Added             = { fg = c.green },
  Changed           = { fg = c.blue },
  Removed           = { fg = c.red },

  -- Legacy syntax fallbacks -------------------------------------------------
  Comment        = { fg = c.muted, italic = true },
  Constant       = { fg = c.orange },
  String         = { fg = c.green },
  Character      = { fg = c.yellow },
  Number         = { fg = c.orange },
  Boolean        = { fg = c.orange },
  Float          = { fg = c.orange },
  Identifier     = { fg = c.fg },
  Function       = { fg = c.blue },
  Statement      = { fg = c.purple },
  Keyword        = { fg = c.purple, italic = true },
  Conditional    = { fg = c.purple, italic = true },
  Repeat         = { fg = c.purple, italic = true },
  Operator       = { fg = c.cyan },
  PreProc        = { fg = c.purple },
  Include        = { fg = c.purple },
  Define         = { fg = c.purple },
  Macro          = { fg = c.purple },
  Type           = { fg = c.yellow },
  StorageClass   = { fg = c.yellow },
  Structure      = { fg = c.yellow },
  Typedef        = { fg = c.yellow },
  Special        = { fg = c.cyan },
  Delimiter      = { fg = c.cyan },
  Tag            = { fg = c.red },
  Label          = { fg = c.red },
  Error          = { fg = c.red },
  Todo           = { fg = c.bg, bg = c.yellow, bold = true },

  -- Treesitter (maps Zed syntax tokens) ------------------------------------
  ["@comment"]                 = { fg = c.muted, italic = true },
  ["@comment.documentation"]   = { fg = c.muted, italic = true },
  ["@keyword"]                 = { fg = c.purple, italic = true },
  ["@keyword.function"]        = { fg = c.purple, italic = true },
  ["@keyword.return"]          = { fg = c.purple, italic = true },
  ["@keyword.operator"]        = { fg = c.purple, italic = true },
  ["@keyword.conditional"]     = { fg = c.purple, italic = true },
  ["@keyword.repeat"]          = { fg = c.purple, italic = true },
  ["@keyword.import"]          = { fg = c.purple, italic = true },
  ["@keyword.directive"]       = { fg = c.purple }, -- preproc
  ["@function"]                = { fg = c.blue },
  ["@function.call"]           = { fg = c.blue },
  ["@function.method"]         = { fg = c.blue },
  ["@function.method.call"]    = { fg = c.blue },
  ["@function.builtin"]        = { fg = c.blue, italic = true }, -- function.special
  ["@constructor"]             = { fg = c.blue },
  ["@type"]                    = { fg = c.yellow },
  ["@type.builtin"]            = { fg = c.yellow },
  ["@type.definition"]         = { fg = c.yellow },
  ["@attribute"]               = { fg = c.purple },
  ["@variable"]                = { fg = c.fg },
  ["@variable.builtin"]        = { fg = c.red, italic = true }, -- variable.special
  ["@variable.parameter"]      = { fg = c.fg },
  ["@variable.member"]         = { fg = c.red }, -- property
  ["@property"]                = { fg = c.red },
  ["@field"]                   = { fg = c.red },
  ["@constant"]                = { fg = c.orange },
  ["@constant.builtin"]        = { fg = c.orange },
  ["@constant.macro"]          = { fg = c.purple },
  ["@module"]                  = { fg = c.fg },
  ["@label"]                   = { fg = c.red },
  ["@string"]                  = { fg = c.green },
  ["@string.escape"]           = { fg = c.fg },
  ["@string.regexp"]           = { fg = c.cyan },
  ["@string.special"]          = { fg = c.green },
  ["@string.special.symbol"]   = { fg = c.yellow },
  ["@character"]               = { fg = c.yellow },
  ["@number"]                  = { fg = c.orange },
  ["@number.float"]            = { fg = c.orange },
  ["@boolean"]                 = { fg = c.orange },
  ["@operator"]                = { fg = c.cyan },
  ["@punctuation.delimiter"]   = { fg = c.cyan },
  ["@punctuation.bracket"]     = { fg = c.cyan },
  ["@punctuation.special"]     = { fg = c.cyan },
  ["@tag"]                     = { fg = c.red },
  ["@tag.attribute"]           = { fg = c.purple },
  ["@tag.delimiter"]           = { fg = c.cyan },
  -- markup (markdown, etc.)
  ["@markup.heading"]          = { fg = c.blue, bold = true },
  ["@markup.strong"]           = { fg = c.fg, bold = true },
  ["@markup.italic"]           = { fg = c.fg, italic = true },
  ["@markup.raw"]              = { fg = c.green }, -- text.literal
  ["@markup.link"]             = { fg = c.orange }, -- link_text
  ["@markup.link.url"]         = { fg = c.cyan }, -- link_uri
  ["@markup.link.label"]       = { fg = c.orange },
  ["@markup.list"]             = { fg = c.blue }, -- list_marker

  -- Semantic tokens (gopls & friends) --------------------------------------
  ["@lsp.type.namespace"]      = { fg = c.fg },
  ["@lsp.type.type"]           = { fg = c.yellow },
  ["@lsp.type.class"]          = { fg = c.yellow },
  ["@lsp.type.enum"]           = { fg = c.yellow },
  ["@lsp.type.interface"]      = { fg = c.yellow },
  ["@lsp.type.struct"]         = { fg = c.yellow },
  ["@lsp.type.enumMember"]     = { fg = c.yellow }, -- variant
  ["@lsp.type.parameter"]      = { fg = c.fg },
  ["@lsp.type.variable"]       = { fg = c.fg },
  ["@lsp.type.property"]       = { fg = c.red },
  ["@lsp.type.function"]       = { fg = c.blue },
  ["@lsp.type.method"]         = { fg = c.blue },
  ["@lsp.type.keyword"]        = { fg = c.purple, italic = true },
  ["@lsp.type.comment"]        = { fg = c.muted, italic = true },

  -- gitsigns ----------------------------------------------------------------
  GitSignsAdd       = { fg = c.green },
  GitSignsChange    = { fg = c.blue },
  GitSignsDelete    = { fg = c.red },

  -- neo-tree ----------------------------------------------------------------
  NeoTreeNormal        = { fg = c.fg, bg = c.bg_dark },
  NeoTreeNormalNC      = { fg = c.fg, bg = c.bg_dark },
  NeoTreeDirectoryName = { fg = c.fg },
  NeoTreeDirectoryIcon = { fg = c.blue },
  NeoTreeRootName      = { fg = c.blue, bold = true },
  NeoTreeFileName      = { fg = c.fg },
  NeoTreeIndentMarker  = { fg = c.bg_elem },
  NeoTreeGitAdded      = { fg = c.green },
  NeoTreeGitModified   = { fg = c.blue },
  NeoTreeGitDeleted    = { fg = c.red },
  NeoTreeGitUntracked  = { fg = c.yellow },
  NeoTreeGitIgnored    = { fg = c.muted },

  -- snacks.nvim picker (LazyVim default fuzzy finder) -----------------------
  SnacksPicker            = { fg = c.fg, bg = c.bg_dark },
  SnacksPickerBorder      = { fg = c.bg_elem, bg = c.bg_dark },
  SnacksPickerTitle       = { fg = c.blue, bg = c.bg_dark, bold = true },
  SnacksPickerMatch       = { fg = c.blue, bold = true },
  SnacksPickerDir         = { fg = c.muted },
  SnacksPickerFile        = { fg = c.fg },
  SnacksPickerPathIgnored = { fg = c.dim }, -- git-ignored files (was NonText, ~invisible)
  SnacksPickerPathHidden  = { fg = c.dim }, -- hidden files
  SnacksPickerPrompt      = { fg = c.blue },
  SnacksPickerListCursorLine = { bg = c.bg_pick_sel },

  -- blink.cmp ---------------------------------------------------------------
  BlinkCmpMenu            = { fg = c.fg, bg = c.bg_dark },
  BlinkCmpMenuBorder      = { fg = c.bg_elem, bg = c.bg_dark },
  BlinkCmpMenuSelection   = { bg = c.bg_elem },
  BlinkCmpLabel           = { fg = c.fg },
  BlinkCmpLabelMatch      = { fg = c.blue, bold = true },
  BlinkCmpKind            = { fg = c.blue },
  BlinkCmpDoc             = { fg = c.fg, bg = c.bg_dark },
  BlinkCmpDocBorder       = { fg = c.bg_elem, bg = c.bg_dark },

  -- flash.nvim --------------------------------------------------------------
  FlashLabel        = { fg = c.bg, bg = c.red, bold = true },
  FlashMatch        = { fg = c.fg, bg = c.bg_ref },
  FlashCurrent      = { fg = c.bg, bg = c.yellow },

  -- which-key ---------------------------------------------------------------
  WhichKey          = { fg = c.blue },
  WhichKeyGroup     = { fg = c.purple },
  WhichKeyDesc      = { fg = c.fg },
  WhichKeySeparator = { fg = c.muted },
  WhichKeyFloat     = { bg = c.bg_dark },
  WhichKeyBorder    = { fg = c.bg_elem, bg = c.bg_dark },

  -- trouble -----------------------------------------------------------------
  TroubleNormal     = { fg = c.fg, bg = c.bg_dark },
  TroubleText       = { fg = c.fg },
  TroubleCount      = { fg = c.purple, bold = true },

  -- bufferline / tabs accents ----------------------------------------------
  Substitute        = { fg = c.bg, bg = c.orange },
}

for group, spec in pairs(groups) do
  hl(group, spec)
end

-- Terminal ANSI colors (matches Zed terminal.ansi.*) ------------------------
vim.g.terminal_color_0  = c.bg
vim.g.terminal_color_1  = c.red
vim.g.terminal_color_2  = c.green
vim.g.terminal_color_3  = c.yellow
vim.g.terminal_color_4  = c.blue
vim.g.terminal_color_5  = c.purple
vim.g.terminal_color_6  = c.cyan
vim.g.terminal_color_7  = c.fg
vim.g.terminal_color_8  = c.muted
vim.g.terminal_color_9  = c.red
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.yellow
vim.g.terminal_color_12 = c.blue
vim.g.terminal_color_13 = c.purple
vim.g.terminal_color_14 = c.cyan
vim.g.terminal_color_15 = c.fg_bright
