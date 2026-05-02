# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt6ct
eval "$(starship init bash)"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=~/.npm-global/bin:$PATH
export EDITOR=nvim
export VISUAL=nvim

cdf() {
  local dir
  dir=$(fd --type d --hidden --follow --max-depth 5 --exclude .git --exclude node_modules --exclude .cache 2>/dev/null |
    fzf --query "$1" --height 60% --reverse --border) && cd "$dir"
}

# Custom aliases
alias fetch='nitch'
alias python='python3'
alias open='xdg-open'
alias zen='flatpak run app.zen_browser.zen'
alias ls='lsd'
alias :q='exit'
alias vim='nvim'

. "$HOME/.cargo/env"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(atuin init bash)"
