# dotfiles

Personal dotfiles for macOS. Configs live at the repo root mirroring `$HOME`
and are symlinked into place with **GNU stow**. Packages are installed with a
**Brewfile**. Machine-specific and corporate/secret settings are kept out of
git via **local overlays**.

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

## How it's organized: shared config + local overlays

Everything in this repo is **shared/portable** — safe on any machine. Anything
machine-specific, corporate, or secret lives in **untracked local overlays**
that the shared config sources automatically if present:

| Shared (tracked here)            | Local overlay (untracked, per-machine)        |
| -------------------------------- | --------------------------------------------- |
| `.zshrc` (paths, prompt, aliases)| `~/.zshrc.local`  (secrets, corporate env)    |
| `.gitconfig` (aliases, colors)   | `~/.gitconfig.local` (email, corp url rewrites)|

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

**Symlinked configs:** `.zshrc`, `.gitconfig`, and under `.config/`:
`nvim/`, `ghostty/`, `lazygit/`, `starship.toml`, plus `zed/`
(`settings.json`, `keymap.json`, `themes/`).

**Intentionally NOT tracked** (runtime/state/secrets — see `.gitignore`):
Zed `prompts/` DB; all of **Claude Code** (`~/.claude/`) and **opencode**
(`~/.config/opencode/`) — their model/provider config is corporate, some
commands/skills are third-party (not mine), and the rest is runtime state, so
they're managed only locally.

- **Terminal:** [Ghostty](https://ghostty.org/) — theme *OpenCode Material*
  (`.config/ghostty/themes/`), font *BerkeleyMono Nerd Font* (vendored in `fonts/`).
- **Editor:** [Neovim](https://neovim.io/) (LazyVim) — plugin versions pinned
  via `.config/nvim/lazy-lock.json`. Personal cheatsheet tracked at
  `Notes/Tech/Neovim.md` (symlinked to `~/Notes/Tech/Neovim.md`).
- **Prompt:** [Starship](https://starship.rs/).

## Packages

`brew bundle` (`Brewfile`) installs formulae, casks, and taps. Deliberately
excluded: Go tooling (managed by the Go version manager + `go install`),
corporate/internal taps, and heavy work-stack tools (left commented in the
Brewfile for easy re-add). `npm`/`cargo` globals are installed by
`bootstrap.sh` (they aren't standard `brew bundle` directives on vanilla brew).

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
