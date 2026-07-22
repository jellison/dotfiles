#!/usr/bin/env bash
# Idempotent setup for a new (personal) machine.
#   git clone git@github.com:jellison/dotfiles.git ~/code/dotfiles
#   cd ~/code/dotfiles && ./bootstrap.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$(dirname "$DOTFILES")"
PKG="$(basename "$DOTFILES")"

echo "==> 1/4 Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# make brew available in this shell (Apple Silicon / Intel)
eval "$([ -x /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew shellenv || /usr/local/bin/brew shellenv)"

echo "==> 2/4 Packages (brew bundle)"
brew bundle --file="$DOTFILES/Brewfile"

echo "==> 3/4 Link dotfiles into \$HOME (GNU stow)"
# Ensure dirs that hold only a tracked file (not the whole dir) exist first, so
# stow symlinks the leaf file instead of folding the entire directory.
mkdir -p "$HOME/Notes/Tech"
if stow --dir="$STOW_DIR" --target="$HOME" --restow "$PKG"; then
  echo "    linked."
else
  echo "    stow reported conflicts (a real file already exists where a symlink"
  echo "    should go). Resolve, then re-run, e.g.:"
  echo "      stow --dir=\"$STOW_DIR\" --target=\"\$HOME\" --adopt \"$PKG\"   # pulls existing file into repo"
  echo "      # or back up/remove the conflicting file, then re-run this script"
fi

echo "==> 4/4 Fonts"
mkdir -p "$HOME/Library/Fonts"
cp -n "$DOTFILES"/fonts/*.OTF "$HOME/Library/Fonts/" 2>/dev/null || true

# Language-manager globals (npm/cargo). Guarded: only run if the toolchain is
# present. On a fresh machine install node (via nvm) / rust first, then re-run.
if command -v npm >/dev/null 2>&1; then
  echo "==> npm globals"
  npm install -g @earendil-works/pi-coding-agent yarn elm-land lamdera
else
  echo "==> skipping npm globals (no npm yet; install node via nvm, then re-run)"
fi
if command -v cargo >/dev/null 2>&1; then
  echo "==> cargo tools"
  cargo install cargo-bundle
fi

cat <<'EOF'

Done. Manual follow-ups (not handled by this script):
  * Go toolchain — install via your Go version manager (company/personal method),
    then `go install` gopls/gofumpt/goimports/delve as needed.
  * On first `nvim` launch, plugins install pinned to lua/lazy-lock.json.
  * BerkeleyMono is licensed to you; its font files are vendored in fonts/.
EOF
