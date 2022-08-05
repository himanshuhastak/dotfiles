# shellcheck shell=bash
# shellcheck disable=SC2086 ## Double quote to prevent globbing and word splitting.
#GENERAL
alias g='gvim -o' # alias gvim
alias h='history'
alias s='source'
alias mkdir='mkdir -pv' # make parentdir

COLOR="--color=auto"
#LS
alias l='ls'                # l to ls
alias ls='ls --color'       # color ls
alias ll='ls -al'           # longlist
alias ls.='ls -d .* $COLOR' # show hidden files
alias lsd='ls -d */ $COLOR' # show all dirs
#GREP COLOUR
alias grep='grep $COLOR' # color grep
#COLORDIFF
#alias diff='colordiff'

#MISC
alias df='df -h'  # df human redable
alias du='du -sh' # du human readable
alias rm='rm -iv' # prompt before removal
alias mv='mv -iv' # prompt before removal

alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

alias tao='task add project:office'
alias TAR='tar -cvzf'
alias UNTAR='tar -xvzf'

#GIT ALIASES
alias gcl='git clone'
alias gpul='git pull'
alias ga='git add'
alias grm='git rm'
alias gcm='git commit -m'
alias gpu='git push -u origin master'

#FUNCTIONS
mkcd() {
    mkdir "${1}"
    cd "${1}" || echo 'Error changing to' "${1}"
}

GIT() {
    IFS=$'\n'
    local file="$1"
    local comment="$2"
    ga "$file"
    gcm "$comment"
    gpu
}

# force git pull --- similar to p4 sync -f
FGPULL() {
    local branch=${1:-master}
    git fetch --all
    git reset --hard origin/$branch
}

Calc() {
    #shellcheck disable=2027 # The surrounding quotes actually unquote this. Remove or escape them.
    python -c "from math import *  ; print "${*}" "
}

snow() {
    clear
    while :; do
        echo $LINES $COLUMNS $(($RANDOM % $COLUMNS))
        sleep 0.1
    done | gawk '{a[$3]=0;for(x in a) {o=a[x];a[x]=a[x]+1;printf "\033[%s;%sH ",o,x;printf "\033[%s;%sH*\033[0;0H",a[x],x;}}'
}

cmdHist() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a; }' |
        grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}

#Following code is copied from ::-
#https://stackoverflow.com/questions/24515385/is-there-a-general-way-to-add-prepend-remove-paths-from-general-environment-vari

prepend() {
    local var=$1
    local val=$2
    local sep=${3:-":"}
    [[ ${!var} =~ (^|"$sep")"$val"($|"$sep") ]] && return        # already present
    [[ ${!var} ]] || { printf -v "$var" '%s' "$val" && return; } # empty
    printf -v "$var" '%s%s%s' "$val" "$sep" "${!var}"            # prepend
}

append() {
    local var=$1
    local val=$2
    local sep=${3:-":"}
    [[ ${!var} =~ (^|"$sep")"$val"($|"$sep") ]] && return        # already present
    [[ ${!var} ]] || { printf -v "$var" '%s' "$val" && return; } # empty
    printf -v "$var" '%s%s%s' "${!var}" "$sep" "${val}"          # append
}

remove() {
    local var=$1
    local val=$2
    local sep=${3:-":"}
    while [[ ${!var} =~ (^|.*"$sep")"$val"($|"$sep".*) ]]; do
        if [[ ${BASH_REMATCH[1]} && ${BASH_REMATCH[2]} ]]; then # match is between both leading and trailing content
            printf -v "$var" '%s%s' "${BASH_REMATCH[1]%$sep}" "${BASH_REMATCH[2]}"
        elif [[ ${BASH_REMATCH[1]} ]]; then # match is at the end
            #shellcheck disable=SC2059 #Don't use variables in the printf format string. Use printf '..%s..' "$foo".
            printf -v "$var" "${BASH_REMATCH[1]%$sep}"
        else # match is at the beginning
            #shellcheck disable=SC2059 #Don't use variables in the printf format string. Use printf '..%s..' "$foo".
            printf -v "$var" "${BASH_REMATCH[2]#$sep}"
        fi
    done
}

alias TOUCH="find -type f -exec touch {} +"
alias g="gvim -p"
# alias ls="ls --color"
alias tmuxKill='tmux kill-server'
alias vncserver="vncserver :51"
# alias tao='task add project:office'
alias grep="egrep -n"
alias ssh="ssh -Y"
alias less="less -N -i -M -FsRXc -w  "
alias sdiff="sdiff --ignore-tab-expansion --ignore-space-change --ignore-all-space --ignore-blank-lines --strip-trailing-cr --text --minimal --speed-large-files --suppress-common-lines "
#### We can do the below kinds of alias hack because we have prepend PATH ~/bin
alias scp="rsync.sh"
alias cp="rsync.sh"

allcolors() {
    #Color_Off='\e[0m'       # Text Reset
    #
    ## Regular Colors
    #Black='\e[0;30m'        # Black
    #Red='\e[0;31m'          # Red
    #Green='\e[0;32m'        # Green
    #Yellow='\e[0;33m'       # Yellow
    #Blue='\e[0;34m'         # Blue
    #Purple='\e[0;35m'       # Purple
    #Cyan='\e[0;36m'         # Cyan
    #White='\e[0;37m'        # White
    #
    ## Bold
    #BBlack='\e[1;30m'       # Black
    #BRed='\e[1;31m'         # Red
    #BGreen='\e[1;32m'       # Green
    #BYellow='\e[1;33m'      # Yellow
    #BBlue='\e[1;34m'        # Blue
    #BPurple='\e[1;35m'      # Purple
    #BCyan='\e[1;36m'        # Cyan
    #BWhite='\e[1;37m'       # White
    #
    ## Underline
    #UBlack='\e[4;30m'       # Black
    #URed='\e[4;31m'         # Red
    #UGreen='\e[4;32m'       # Green
    #UYellow='\e[4;33m'      # Yellow
    #UBlue='\e[4;34m'        # Blue
    #UPurple='\e[4;35m'      # Purple
    #UCyan='\e[4;36m'        # Cyan
    #UWhite='\e[4;37m'       # White
    #
    ## Background
    #On_Black='\e[40m'       # Black
    #On_Red='\e[41m'         # Red
    #On_Green='\e[42m'       # Green
    #On_Yellow='\e[43m'      # Yellow
    #On_Blue='\e[44m'        # Blue
    #On_Purple='\e[45m'      # Purple
    #On_Cyan='\e[46m'        # Cyan
    #On_White='\e[47m'       # White
    #
    ## High Intensity
    #IBlack='\e[0;90m'       # Black
    #IRed='\e[0;91m'         # Red
    #IGreen='\e[0;92m'       # Green
    #IYellow='\e[0;93m'      # Yellow
    #IBlue='\e[0;94m'        # Blue
    #IPurple='\e[0;95m'      # Purple
    #ICyan='\e[0;96m'        # Cyan
    #IWhite='\e[0;97m'       # White
    #
    ## Bold High Intensity
    #BIBlack='\e[1;90m'      # Black
    #BIRed='\e[1;91m'        # Red
    #BIGreen='\e[1;92m'      # Green
    #BIYellow='\e[1;93m'     # Yellow
    #BIBlue='\e[1;94m'       # Blue
    #BIPurple='\e[1;95m'     # Purple
    #BICyan='\e[1;96m'       # Cyan
    #BIWhite='\e[1;97m'      # White
    #
    ## High Intensity backgrounds
    #On_IBlack='\e[0;100m'   # Black
    #On_IRed='\e[0;101m'     # Red
    #On_IGreen='\e[0;102m'   # Green
    #On_IYellow='\e[0;103m'  # Yellow
    #On_IBlue='\e[0;104m'    # Blue
    #On_IPurple='\e[0;105m'  # Purple
    #On_ICyan='\e[0;106m'    # Cyan
    #On_IWhite='\e[0;107m'   # White

    # http://askubuntu.com/a/279014
    for x in 0 1 4 5 7 8; do
        for i in $(seq 30 37); do
            for a in $(seq 40 47); do
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
            done
            echo
        done
    done
    echo ""
}

unset COLOR

# shellcheck source=/dev/null                                                                                                   # disable relative path
source ~/.bashrc.hastakh
