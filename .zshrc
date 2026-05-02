# ~/.zshrc

# ======================
# History Settings
# ======================
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ======================
# Basic Zsh Settings
# ======================
bindkey -e

zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit -C

# ======================
# Environment Variables
# ======================
export EDITOR=nvim
export VISUAL=nvim
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt6ct

# PATH
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.npm-global/bin:$PATH"

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ======================
# Modern Tools
# ======================

# Starship Prompt
eval "$(starship init zsh)"

# Atuin
eval "$(atuin init zsh)"

# Zoxide (smart cd) - using `z` command to avoid conflict with `cd`
eval "$(zoxide init zsh)"

# ======================
# fzf Setup
# ======================
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
    source /usr/share/doc/fzf/examples/completion.zsh
fi

export FZF_DEFAULT_OPTS='--height 60% --reverse --border --info=inline --cycle --ansi'

# ======================
# Simple Fuzzy CD Functions (fixed)
# ======================
cdf() {
    local dir
    dir=$(fd --type d --hidden --follow --max-depth 5 --exclude .git --exclude node_modules --exclude .cache 2>/dev/null | \
          fzf --query "$1" --height 60% --reverse --border) && cd "$dir"
}

# Short aliases
alias c='cdf'

# ======================
# Aliases
# ======================
alias fetch='nitch'
alias python='python3'
alias open='xdg-open'
alias zen='flatpak run app.zen_browser.zen'
alias vim='nvim'
alias ls='lsd'
alias :q='exit'

# ======================
# Source custom files (optional)
# ======================
if [ -d ~/.zshrc.d ]; then
  for rc in ~/.zshrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi

unset rc
