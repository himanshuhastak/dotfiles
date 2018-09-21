# shellcheck shell=bash
#GENERAL
alias g='gvim -o'                                                                                                               # alias gvim
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
#COLORDIFF
alias diff='colordiff'

#MISC
alias df='df -h'                                                                                                                # df human redable
alias du='du -sh'                                                                                                               # du human readable        
alias rm='rm -iv'                                                                                                               # prompt before removal
alias mv='mv -iv'                                                                                                               # prompt before removal

alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

alias tao='task add project:office'

#GIT ALIASES
alias gcl='git clone'
alias gpul='git pull'
alias ga='git add'
alias grm='git rm'
alias gcm='git commit -m'
alias gpu='git push -u origin master'


#FUNCTIONS
mkcd () {
    mkdir "${1}"
    cd    "${1}" || echo "Error changing to \"${1}\" "
}

GITit() {
    ga "$1" ;
    gcm "$2"
    gpu
}

Calc () {
    python -c "from math import *  ; print ""${*}"" " ;
}

tarit () {
    tar -czf "$1".tar.gz "$1";
}

snow () {
        clear;while :;do echo $LINES $COLUMNS $(($RANDOM%$COLUMNS));sleep 0.1;done|gawk '{a[$3]=0;for(x in a) {o=a[x];a[x]=a[x]+1;printf "\033[%s;%sH ",o,x;printf "\033[%s;%sH*\033[0;0H",a[x],x;}}'
}

cmdHist () {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a; }' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}

#Following code is copied from ::-
#https://stackoverflow.com/questions/24515385/is-there-a-general-way-to-add-prepend-remove-paths-from-general-environment-vari

prepend() {
  local var=$1
  local val=$2
  local sep=${3:-":"}
  [[ ${!var} =~ (^|"$sep")"$val"($|"$sep") ]] && return                                                                         # already present
  [[ ${!var} ]] || { printf -v "$var" '%s' "$val" && return; }                                                                  # empty
  printf -v "$var" '%s%s%s' "$val" "$sep" "${!var}"                                                                             # prepend
}

append() {
  local var=$1
  local val=$2
  local sep=${3:-":"}
  [[ ${!var} =~ (^|"$sep")"$val"($|"$sep") ]] && return                                                                         # already present
  [[ ${!var} ]] || { printf -v "$var" '%s' "$val" && return; }                                                                  # empty
  printf -v "$var" '%s%s%s' "${!var}" "$sep" "${val}"                                                                           # append
}

remove() {
  local var=$1
  local val=$2
  local sep=${3:-":"}
  while [[ ${!var} =~ (^|.*"$sep")"$val"($|"$sep".*) ]]; do
    if [[ ${BASH_REMATCH[1]} && ${BASH_REMATCH[2]} ]]; then                                                                     # match is between both leading and trailing content
      printf -v "$var" '%s%s' "${BASH_REMATCH[1]%$sep}" "${BASH_REMATCH[2]}"
    elif [[ ${BASH_REMATCH[1]} ]]; then                                                                                         # match is at the end
      printf -v "$var" "${BASH_REMATCH[1]%$sep}"
    else                                                                                                                        # match is at the beginning
      printf -v "$var" "${BASH_REMATCH[2]#$sep}"
    fi
  done
}
# shellcheck source=/dev/null                                                                                                   # disable relative path
source ~/.bashrc.hastakh
