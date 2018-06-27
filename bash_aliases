
alias g='gvim'                                                                                                                  # alias gvim
alias l='ls'                                                                                                                    # l to ls
alias ls='ls --color'                                                                                                           # color ls
alias ll='ls -al'                                                                                                               # longlist
alias ls.='ls -d .* --color=auto'                                                                                               # show hidden files
alias lsd='ls -d */ --color=auto'                                                                                               # show all dirs
alias grep='grep --color=auto'                                                                                                  # color grep
alias mkdir='mkdir -pv'                                                                                                         # make parentdir
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias df='df -h'                                                                                                                # df human redable
alias du='du -sh'                                                                                                               # du human readable        
alias rm='rm -ivf'                                                                                                              # prompt before removal
alias mv='mv -ivf'                                                                                                              # prompt before removal
alias calc='python -c "from math import *; print( \!* )"'                                                                       # calculator from Python
alias h='history'


#FUNCTIONS
mkcd () {
    mkdir $1
    cd    $1
}

