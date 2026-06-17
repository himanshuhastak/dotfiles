# ~/.zshrc — interactive zsh shells

# Universal config shared with bash (env, PATH, functions, aliases).
[[ -r ~/.shrc ]] && . ~/.shrc

# Skip interactive-only setup for scripts and non-interactive shells.
[[ -o interactive ]] || return

# --- zsh-only settings ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt AUTO_CD INTERACTIVE_COMMENTS NO_BEEP

# Completion.
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Emacs keybindings + sane backspace.
bindkey -e
bindkey '^?' backward-delete-char

# --- tool hooks (guarded) ---
if command -v fzf >/dev/null 2>&1 && fzf --zsh >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi
command -v zoxide   >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v atuin    >/dev/null 2>&1 && eval "$(atuin init zsh --disable-up-arrow)"
command -v direnv   >/dev/null 2>&1 && eval "$(direnv hook zsh)"
# broot: defines the `br` launcher (lets you cd into the picked directory).
command -v broot    >/dev/null 2>&1 && eval "$(broot --print-shell-function zsh 2>/dev/null)"

# --- plugins via sheldon (https://github.com/rossmacarthur/sheldon) ---
# Clones live in <repo>/vendor/sheldon (gitignored); config in ~/.config/sheldon.
export SHELDON_DATA_DIR="${DOTFILES_DIR:-$HOME/dotfiles}/vendor/sheldon"
command -v sheldon >/dev/null 2>&1 && eval "$(sheldon source)"

# history-substring-search keybindings (plugin loaded via sheldon).
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

_br_launcher="${XDG_CONFIG_HOME:-$HOME/.config}/broot/launcher/bash/br"
[ -r "$_br_launcher" ] && . "$_br_launcher"
