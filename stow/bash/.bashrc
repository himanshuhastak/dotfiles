# ~/.bashrc — interactive shells hand off to zsh (full bash setup: ~/.bashrc.bkp)

[[ -f /etc/bashrc ]] && . /etc/bashrc
case $- in *i*) ;; *) return ;; esac

export TOOLS_DIR="${TOOLS_DIR:-$HOME/dotfiles/.tools}"
exec zsh
