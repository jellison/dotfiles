# Neovim (LazyVim) Cheatsheet

> Modal editor. `Esc` returns to **Normal** mode (home base). `Space` = leader.
> Press it and pause → which-key shows all options.

#### Mode

## Modes

| Mode    | Enter with       | Purpose                                   |
| ------- | ---------------- | ----------------------------------------- |
| Normal  | `Esc`            | Navigate & run commands (default)         |
| Insert  | `i` `a` `o`      | after cursor / before cursor / after line |
| Visual  | `v` `V` `Ctrl-v` | Select (char / line / block)              |
| Command | `:`              | Editor commands (`:w`, `:%s`, `:123`)     |
| Leader  | `<Space>`        |                                           |

#### Movement

| Action                                  | Keys                  | Notes                                   |
| --------------------------------------- | --------------------- | --------------------------------------- |
| Left / Down / Up / Right                | `h` / `j` / `k` / `l` |                                         |
| Start of line (first non-blank)         | `^`                   |                                         |
| Start of line (column 0)                | `0`                   |                                         |
| End of line                             | `$`                   |                                         |
| Go to column N                          | `N\|`                 |                                         |
| Word forward / back                     | `w` / `b`             | `W` / `B` = WORD (whitespace-delimited) |
| End of word                             | `e`                   | `ge` = end of previous word             |
| Find char in line                       | `f{c}` / `F{c}`       | forward / backward; `;` / `,` repeat    |
| Till char in line                       | `t{c}` / `T{c}`       | stops before the char                   |
| Next / prev paragraph                   | `}` / `{`             | blank-line separated                    |
| Next / prev sentence                    | `)` / `(`             |                                         |
| Matching bracket                        | `%`                   | on `()[]{}` jumps to its pair           |
| First / last line of file               | `gg` / `G`            |                                         |
| Go to line N                            | `NG` or `:N`          |                                         |
| Top / Middle / Bottom of screen         | `H` / `M` / `L`       |                                         |
| Half page down / up                     | `Ctrl-d` / `Ctrl-u`   |                                         |
| Full page down / up                     | `Ctrl-f` / `Ctrl-b`   |                                         |
| Scroll: center / top / bottom on cursor | `zz` / `zt` / `zb`    | moves view, not cursor                  |
| Jump to position before last jump       | ``                    | two backticks                           |
| Jump to last edit                       | `` `. ``              | backtick then dot                       |

#### Navigation

## Navigation

| Action                 | Keys                      | Notes                                  |
| ---------------------- | ------------------------- | -------------------------------------- |
| Back / Forward (jumps) | `Ctrl-o` / `Ctrl-i`       | Jump history                           |
| Buffer Symbol          | `<Space>ss`               | Symbol in current file (outline modal) |
| Buffers                | `<Space>,`                | Open buffers                           |
| Find File              | `<Space><Space>`          | Fuzzy find files in project            |
| Find all References    | `gr`                      |                                        |
| Go to Definition       | `gd`                      |                                        |
| Go to Implementation   | `gI`                      |                                        |
| Go to line             | `:123` or `123G`          |                                        |
| Go to Type / Symbol    | `<Space>sS`               | Workspace symbols (project-wide)       |
| Go to Type Definition  | `gy`                      |                                        |
| Hover docs             | `K`                       |                                        |
| Jump on screen         | `s` + 2 chars             | flash.nvim                             |
| Live grep              | `<Space>/`                | Search text across project             |
| Recent files           | `<Space>fr` / `<Space>fR` | project / all                          |

## UI

| Action                       | Keys                      | Notes                                       |
| ---------------------------- | ------------------------- | ------------------------------------------- |
| File tree pane               | `<Space>e`                | Snacks explorer (toggle)                    |
| Buffer symbols pane          | `<Space>cs`               | Trouble outline for current buffer (toggle) |
| Show hidden files (dotfiles) | `Alt-h`                   | In explorer / any picker; toggle            |
| Show git-ignored files       | `Alt-i`                   | In explorer / any picker; toggle            |
| Markdown render (in-buffer)  | `<Space>um`               | Toggle styled render; cursor line stays raw |
| Markdown preview (browser)   | `<Space>cp`               | Full live preview in browser                |
| Diagnostics list             | `<Space>xx`               | Trouble                                     |
| Toggle format-on-save        | `<Space>uf` / `<Space>uF` | buffer / global                             |
| Switch colorscheme           | `<Space>uC`               | Live theme picker                           |
| Command palette              | `<Space>sc` or `:`        |                                             |
| Toggle terminal              | `Ctrl-/`                  | Open/hide floating terminal (root dir)      |
| Terminal (root / cwd)        | `<Space>ft` / `<Space>fT` |                                             |
| Exit terminal-mode           | `Ctrl-\` `Ctrl-n`         | Back to Normal without hiding               |

## Editing

| Action                        | Keys                      | Notes                                            |
| ----------------------------- | ------------------------- | ------------------------------------------------ |
| Code actions                  | `<Space>ca`               |                                                  |
| Rename symbol                 | `<Space>cr`               | Project-wide                                     |
| Format buffer                 | `<Space>cf`               | Also runs on save                                |
| Revert file (discard changes) | `:e!`                     | Reload buffer from disk                          |
| Delete line                   | `dd`                      |                                                  |
| Duplicate line                | `yyp`                     | Yank + paste                                     |
| Move line / selection up/down | `Alt-k` / `Alt-j`         | Normal, Insert, Visual                           |
| Indent / dedent selection     | `>` / `<`                 | Visual mode; `.` repeats; `3>` = 3 levels        |
| Indent / dedent line          | `>>` / `<<`               | Normal mode                                      |
| Re-indent line / selection    | `==` / `=`                | `=` over a Visual selection                      |
| Change selection              | `c`                       | Visual: delete selection and enter Insert mode   |
| Change selected lines         | `C` / `S`                 | Visual: replace whole highlighted lines          |
| Insert GUID / UUID            | `<Space>ig` / `<Space>iG` | formatted / unformatted; also `:UUID` / `:UUID!` |
| Comment line/selection        | `gcc` / `gc`              |                                                  |
| Undo / Redo                   | `u` / `Ctrl-r`            |                                                  |
| Save / Quit                   | `:w` / `:q`               |                                                  |

## Copy / Paste (Yank / Put)

> `clipboard=unnamedplus` is on, so `y`/`d` sync with the system clipboard (copy
> in nvim → `Cmd+V` elsewhere, and vice versa).

| Action                 | Keys         | Notes                |
| ---------------------- | ------------ | -------------------- |
| Copy selection         | `y`          | in Visual mode       |
| Cut selection          | `d` (or `x`) | in Visual mode       |
| Paste over selection   | `p`          | replaces selection   |
| Paste after / before   | `p` / `P`    | Normal mode          |
| Copy / cut line        | `yy` / `dd`  |                      |
| Copy inner word        | `yiw`        | operator + motion    |
| Paste last _yank_ only | `"0p`        | ignores deleted text |

## Files

| Action                  | Keys                        | Notes                                      |
| ----------------------- | --------------------------- | ------------------------------------------ |
| New file (in tree)      | `a`                         | in neo-tree; `sub/dir/f.go` makes dirs too |
| New directory (in tree) | `A` or name ending `/`      |                                            |
| New file by path        | `:e path/to/f.go` then `:w` | created on save                            |
| Show / change cwd       | `:pwd` / `:cd dir`          |                                            |
| Copy absolute path      | `<Space>fy`                 | to system clipboard                        |
| Copy relative path      | `<Space>fY`                 | relative to cwd                            |
| Copy filename           | `<Space>fN`                 | name only, e.g. `Neovim.md`                |
| Copy directory path     | `<Space>fD`                 | containing folder (absolute)               |

## Multiple Cursors / Selection

| Action                      | Keys            | Notes                         |
| --------------------------- | --------------- | ----------------------------- |
| Visual select               | `v` then motion | e.g. `viw` = inside word      |
| Select line                 | `V`             |                               |
| Column/block select         | `Ctrl-v`        | Then `I`/`A` to insert on all |
| Select all matches (rename) | `<Space>cr`     | Semantic, LSP-based           |
| Find & replace in file      | `:%s/old/new/g` | Add `c` to confirm each       |
| Search word under cursor    | `*` / `#`       | Next / previous               |

## Tabs (Buffers) & Windows

> Your top bar = **buffers** (Neovim's name for open-file tabs). These are your
> "tabs." Ignore the `<leader><tab>` menu — that controls _tab pages_ (split
> layouts), which is a different, rarely-used concept.

| Action                        | Keys                    | Notes                                        |
| ----------------------------- | ----------------------- | -------------------------------------------- |
| Next tab / Prev tab           | `Shift-l` / `Shift-h`   | also `]b` / `[b`                             |
| Close tab                     | `<Space>bd`             | delete buffer                                |
| Close other tabs              | `<Space>bo`             |                                              |
| Close tab + window            | `<Space>bD`             |                                              |
| Switch to last-used tab       | `<Space>bb`             |                                              |
| Focus tree ↔ editor           | `Ctrl-h` / `Ctrl-l`     | left / right window                          |
| Focus split up / down         | `Ctrl-k` / `Ctrl-j`     |                                              |
| Cycle windows                 | `Ctrl-w w`              |                                              |
| Jump to previous window       | `Ctrl-w p`              | quick toggle back                            |
| Split right / below           | `Ctrl-w v` / `Ctrl-w s` |                                              |
| Open file tree (and focus it) | `<Space>e`              | `Enter`/`l` on a file opens + focuses editor |

> Tip: run `:Tutor` once (~20 min) to drill operator+motion grammar
> (`d`,`c`,`y` + `w`,`}`,`i(`…). That's the real Vim superpower.
