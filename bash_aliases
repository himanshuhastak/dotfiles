#GENERAL
alias g='gvim -o'                                                                                                                  # alias gvim
alias h='history'
alias s='source'
alias mkdir='mkdir -pv'                                                                                                         # make parentdir

#LS
alias l='ls'                                                                                                                    # l to ls
alias ls='ls --color'                                                                                                           # color ls
alias ll='ls -al'                                                                                                               # longlist
alias ls.='ls -d .* --color=auto'                                                                                               # show hidden files
alias lsd='ls -d */ --color=auto'                                                                                               # show all dirs
#GREP COLOUR
alias grep='grep --color=auto'                                                                                                  # color grep

#MISC
alias df='df -h'                                                                                                                # df human redable
alias du='du -sh'                                                                                                               # du human readable        
alias rm='rm -iv'                                                                                                              # prompt before removal
alias mv='mv -iv'                                                                                                              # prompt before removal

alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

#GIT ALIASES
alias gcl='git clone'
alias ga='git add'
alias grm='git rm'
alias gcm='git commit -m'
alias gpu='git push -u origin master'


#FUNCTIONS
mkcd () {
    mkdir "${1}"
    cd -v    "${1}" || echo "Error changing to \"${1}\" "
}

ccalc () {
    python -c "from math import *  ; print "${*}" " ;
}

prepend () {
    export "${1}"="${2}":\$"${1}"
}

source ~/.bashrc.hastakh
