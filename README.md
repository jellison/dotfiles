# dotfiles

Personal dotfiles for macOS. Configs live at the repo root mirroring `$HOME` and
are symlinked into place with **GNU stow**. Packages are installed with a
**Brewfile**. Machine-specific and corporate/secret settings are kept out of git
via **local overlays**.

## Setup (new machine)

```sh
git clone git@github.com:jellison/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles && ./bootstrap.sh
```

`bootstrap.sh` is idempotent and:

1. installs Homebrew (if missing),
2. installs packages via `brew bundle` (see `Brewfile`),
3. symlinks configs into `$HOME` with `stow`,
4. installs the vendored fonts,
5. installs npm/cargo globals (if node/cargo are present).

If stow reports a conflict (a real file sits where a symlink should go), it
prints the `--adopt` / backup remedies and you re-run.

## How it's organized: shared config + local overlays

Everything in this repo is **shared/portable** — safe on any machine. Anything
machine-specific, corporate, or secret lives in **untracked local overlays**
that the shared config sources automatically if present:

| Shared (tracked here)             | Local overlay (untracked, per-machine)          |
| --------------------------------- | ----------------------------------------------- |
| `.zshrc` (paths, prompt, aliases) | `~/.zshrc.local` (secrets, corporate env)       |
| `.gitconfig` (aliases, colors)    | `~/.gitconfig.local` (email, corp url rewrites) |

- `.zshrc` ends with: `[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local`
- `.gitconfig` starts with: `[include] path = ~/.gitconfig.local`

A machine simply omits the overlay to skip those bits. **The overlays contain
secrets and are never committed** (also blocked by `.gitignore`).

### Per-machine overlay setup

On a **new/personal** machine, create your own overlays:

```sh
# ~/.gitconfig.local
[user]
	email = you@personal.example

# ~/.zshrc.local  (optional; only if you have machine-specific env)
```

On a **corporate** machine, the overlay holds work email, internal git URL
rewrites, proxy/cert env, tokens, and work-only aliases/functions.

## What's managed

**Symlinked configs:** `.zshrc`, `.gitconfig`, and under `.config/`: `nvim/`,
`ghostty/`, `lazygit/`, `starship.toml`, plus `zed/` (`settings.json`,
`keymap.json`, `themes/`).

**Intentionally NOT tracked** (runtime/state/secrets — see `.gitignore`): Zed
`prompts/` DB; all of **Claude Code** (`~/.claude/`) and **opencode**
(`~/.config/opencode/`) — their model/provider config is corporate, some
commands/skills are third-party (not mine), and the rest is runtime state, so
they're managed only locally.

## Terminal: Ghostty

[Ghostty](https://ghostty.org/) is the terminal (`.config/ghostty/config`). The
font is _BerkeleyMono Nerd Font_ (vendored in `fonts/`, see below) and the theme
follows the macOS system appearance automatically: _OpenCode Material_ in dark
mode, _OpenCode Material Light_ in light (both in `.config/ghostty/themes/`). A
few behaviors worth knowing:

- **Layout persistence** (`window-save-state = always`): windows, tabs, splits,
  and their working directories are restored across quit and reboot.
- **Left Option is Alt** (`macos-option-as-alt = left`): so `<A-…>` keybinds
  reach Neovim, while right Option still types special characters (é, –, etc.).
- **Shift+Enter sends a plain newline** (`keybind = shift+enter=text:\n`): lets
  terminal agents and REPLs insert a newline without submitting.

## Editor: Neovim

[Neovim](https://neovim.io/) runs on [LazyVim](https://www.lazyvim.org/), with
plugin versions pinned via `.config/nvim/lazy-lock.json` (first launch installs
against that lockfile). Customizations live under `.config/nvim/lua/`. The
personal keybinding cheatsheet is `Notes/Tech/Neovim.md`. Notable behavior:

- **Theme follows the system:** `auto-dark-mode.nvim` polls the macOS appearance
  and switches between the `opencode-material-dark` / `opencode-material-light`
  colorschemes, matching Ghostty. A pantry of extra themes is installed for live
  switching via `<leader>uC`.
- **Per-workspace session restore:** a bare `nvim` restores the buffers/windows
  saved for that working directory (via persistence.nvim, keyed by cwd + branch)
  and opens the file explorer on the left. No dashboard. `nvim <file>` just
  opens that file.
- **Workspace root is always cwd** (`vim.g.root_spec = { "cwd" }`): opening a
  file, including a symlink into another repo, never moves the root. Change it
  explicitly with `:cd` or the worktree switcher.
- **Git worktree switcher** (`<leader>gw`): lists `git worktree list` and jumps
  cwd to the chosen worktree, then opens its finder.
- **Obsidian vault editing:** `obsidian.nvim` edits `~/Notes` while staying
  compatible with Obsidian itself (daily notes, `_Attachments/` image pastes as
  `![[wiki]]` embeds, wikilink navigation and backlinks).
- **Inline images and markdown:** `render-markdown.nvim` gives an Obsidian-like
  read (toggle with `<leader>um`), and `Snacks.image` renders images inline via
  the Kitty graphics protocol (requires ImageMagick, in the Brewfile).
- **Quality-of-life:** per-window winbar filename labels, project-scoped recent
  files (`<leader>fr`), a centered floating terminal (`<C-/>`), and a pure-Lua
  v4 UUID inserter (`<leader>ig` / `:UUID`).
- **Go tooling** bypasses Mason and uses the `gopls`/`goimports`/`gofumpt`
  already on `PATH` (avoids Mason's from-source builds failing on mismatched Go
  toolchains).

## Prompt

[Starship](https://starship.rs/) (`.config/starship.toml`).

## Packages

`brew bundle` (`Brewfile`) installs formulae, casks, and taps. Alongside the
usual CLI tools it pulls the terminal agents (`opencode`, `claude-tui`
statusline) and Ghostty. Deliberately excluded: Go tooling (managed by the Go
version manager + `go install`), corporate/internal taps, retired terminals, and
the heavy work stack (docker/k8s/kafka/temporal/postgres/bazel/...), left
commented in the Brewfile for easy re-add. `npm`/`cargo` globals are installed
by `bootstrap.sh` (they aren't standard `brew bundle` directives on vanilla
brew).

## Fonts

`fonts/` holds the licensed **BerkeleyMono Nerd Font** (private repo).
`bootstrap.sh` copies them into `~/Library/Fonts`.

## Manual follow-ups (not automated)

- **Go toolchain** — install via your Go version manager, then `go install`
  gopls / gofumpt / goimports / delve as needed.
- Some corporate CLIs live behind internal taps and are not in the Brewfile.

## Security note

Secrets historically lived in plaintext in `.zshrc`; they now live in
`~/.zshrc.local` (untracked). Consider rotating them and sourcing from a secret
manager (e.g. 1Password `op read`) rather than plaintext exports.
