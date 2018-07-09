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

prepend() {
  local var=$1
  local val=$2
  local sep=${3:-":"}
  [[ ${!var} =~ (^|"$sep")"$val"($|"$sep") ]] && return # already present
  [[ ${!var} ]] || { printf -v "$var" '%s' "$val" && return; } # empty
  printf -v "$var" '%s%s%s' "$val" "$sep" "${!var}" # prepend
}

append() {
  local var=$1
  local val=$2
  local sep=${3:-":"}
  [[ ${!var} =~ (^|"$sep")"$val"($|"$sep") ]] && return # already present
  [[ ${!var} ]] || { printf -v "$var" '%s' "$val" && return; } # empty
  printf -v "$var" '%s%s%s' "${!var}" "$sep" "${val}" # append
}

remove() {
  local var=$1
  local val=$2
  local sep=${3:-":"}
  while [[ ${!var} =~ (^|.*"$sep")"$val"($|"$sep".*) ]]; do
    if [[ ${BASH_REMATCH[1]} && ${BASH_REMATCH[2]} ]]; then
      # match is between both leading and trailing content
      printf -v "$var" '%s%s' "${BASH_REMATCH[1]%$sep}" "${BASH_REMATCH[2]}"
    elif [[ ${BASH_REMATCH[1]} ]]; then
      # match is at the end
      printf -v "$var" "${BASH_REMATCH[1]%$sep}"
    else
      # match is at the beginning
      printf -v "$var" "${BASH_REMATCH[2]#$sep}"
    fi
  done
}

source ~/.bashrc.hastakh
