# Brewfile — personal (non-corporate) machine.
# Apply with:  brew bundle --file=Brewfile
# Regenerate:  brew bundle dump --file=Brewfile --force   (then re-curate)
#
# Deliberately EXCLUDED from this file:
#   * Go tooling  -> managed via your Go version manager + `go install`, not brew
#   * Corporate/internal taps & formulae (crowdstrike/*, go-ce/*, kubectl-login,
#     mctunnel) -> live behind internal URLs; not usable off-corp
#   * Retired terminals (iterm2, warp) -> you're on Ghostty now
#   * Heavy work stack (docker/k8s/kafka/temporal/postgres/bazel/...) -> see the
#     commented "OPTIONAL / WORK STACK" block at the bottom; uncomment if wanted

# --- public taps -----------------------------------------------------------
tap "anomalyco/tap"        # opencode
tap "slima4/claude-tui"    # Claude Code statusline

# --- shell / cli -----------------------------------------------------------
brew "bash"
brew "bat"
brew "deno"
brew "difftastic"
brew "eza"
brew "fd"                  # nvim (Snacks file finder)
brew "ripgrep"             # nvim (Snacks live grep)
brew "git"
brew "git-delta"
brew "git-lfs"
brew "httpie"
brew "jq"
brew "neovim"
brew "pngpaste"            # clipboard image paste into terminal agents
brew "starship"
brew "stow"                # symlinks dotfiles into $HOME (see bootstrap.sh)
brew "tmux"
brew "wget"
brew "zsh-autosuggestions"
brew "zellij"              # (shelved for now, but harmless to have)

# --- version managers ------------------------------------------------------
brew "nvm"
brew "pipx"

# --- agents ----------------------------------------------------------------
brew "anomalyco/tap/opencode"
brew "slima4/claude-tui/claude-tui"

# --- casks (apps & fonts) --------------------------------------------------
cask "ghostty"
cask "alt-tab"
cask "hiddenbar"
cask "jordanbaird-ice"
cask "marta"
cask "meld"
cask "opencode-desktop"

# --- npm globals -----------------------------------------------------------
# NOTE: npm/cargo/krew are NOT standard `brew bundle` directives (your corporate
# brew is patched to support them). Installed via bootstrap.sh instead so this
# works on a vanilla Homebrew.

# ===========================================================================
# OPTIONAL / WORK STACK — uncomment any you also use on this personal machine
# ===========================================================================
# brew "colima"
# brew "docker"
# brew "docker-buildx"
# brew "docker-compose"
# brew "docker-credential-helper"
# brew "kubernetes-cli"
# brew "k9s"
# brew "lazydocker"
# brew "temporal"
# brew "zookeeper"
# brew "librdkafka"
# brew "bazelisk"
# brew "buildifier"
# brew "hadolint"
# brew "yara"
# brew "postgresql@17"
# brew "graphviz"
# brew "fswatch"
# brew "duti"
