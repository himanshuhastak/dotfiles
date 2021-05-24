cat <<-EOF > new.bash
#! /usr/bin/env bash
# ------------------------------------------------
# Author:       ${USER}
# Created:      $(TZ=Asia/Calcutta date)
#
# Modifier:     ${USER}
# Modified:     $(TZ=Asia/Calcutta date)
#
# Usage:
#       <script_name>.sh --help
#
# Description:
#           {what does script do}
#
# Tool Versions:
#       GNU bash, version 4.2.46(2)-release or later
#       getopt from util-linux 2.23.2 or later
# ------------------------------------------------

## shellcheck disable=SC2086 ## Double quote to prevent globbing and word splitting.
## shellcheck disable=SC2046 ## Quote this to prevent word splitting.        #useful in '\$(find ......)'
## shellcheck disable=SC1090 ## Can't follow non-constant source. Use a directive to specify location.
## shellcheck disable=SC1091 ## Not following: <filename> was not specified as input (see shellcheck -x).

#set -o xtrace      # set -x
set -o errexit     # set -e : Used to exit upon error, avoiding cascading errors
set -o pipefail    # Unveils hidden  pipe failures
#set -o nounset     # Used for [[ -v \$VAR ]]
set -o errtrace

# 2>&1              # Redirrect stderr to stdout
#IFS=$' \n\t'       # separator=space/newline/tsab

export FILE="\${0##*/}"
export CUR_DIR=\$PWD
export SCRIPTS_DIR="\${0%/*}"

function cleanUp() {
    doErr "Aborted by signal"
}
trap cleanUp SIGHUP SIGINT SIGTERM

trapErr() {
    doErr "\${BASH_SOURCE[1]} at about \${BASH_LINENO[0]}"
}

trap trapErr ERR

function doErr() {
    echo -en "\$RED"
    echo -en "[ERROR]: "
    echo -en "\$RED "
    echo -en "\$*"
    echo -e "\$RESET" 1>&2
    usage
    sleep 1
    exit 1
}

function doWarn() {
    echo -en "\$YELLOW"
    echo -en "[WARNING]: "
    echo -en "\$YELLOW "
    echo -en "\$*"
    echo -e "\$RESET" 1>&2
}

function usage() {
    colors
    echo -e "\$MAGENTA \$START_UNDERLINE"
    echo usage:
    echo -e "\$END_UNDERLINE \$RESET"

    grep "[[:space:]].*-.*)[[:space:]].*" "\$FILE" | sed 's/###//g' | sed '/grep/d' | sed 's/#//g'
}


function displayTime {
    local T=$1
    local D=\$((T / 60 / 60 / 24))
    local H=\$((T / 60 / 60 % 24))
    local M=\$((T / 60 % 60))
    local S=\$((T % 60))
    [[ \$D -gt 0 ]] && printf '%d days '    \$D
    [[ \$H -gt 0 ]] && printf '%d hours '   \$H
    [[ \$M -gt 0 ]] && printf '%d minutes ' \$M
    #[[ \$D -gt 0 || \$H -gt 0 || \$M -gt 0 ]] && printf 'and '
    printf '%d seconds\n'   \$S
}

function colors() {

    RED=\$(tput setaf 1)
    YELLOW=\$(tput setaf 3)
    MAGENTA=\$(tput setaf 5)
    #DIM=\$(tput dim)
    START_UNDERLINE=\$(tput smul)
    END_UNDERLINE=\$(tput rmul)
    BOLD=\$(tput bold)
    RESET=\$(tput sgr0)

    export RED
    export YELLOW
    export MAGENTA
    #export DIM
    export START_UNDERLINE
    export END_UNDERLINE
    export BOLD
    export RESET

}

function getOptsOptions() {

    # single colon ':' means that it argument is required.
    export SHORTOPTS="f:a:h"
    export LONGOPTS_WITH_ARG="file-name:,action:"
    export LONGOPTS_WITHOUT_ARG="help"

}

function getOpt() {

    colors
    shopt -s nocasematch

    [ \$# -eq 0 ] && doErr "No Options Passed"
    # [ \$# -eq 0 ] && doWarn "No Options Passed; using default"
    getOptsOptions ## Call function

    OPT_CMD="getopt --alternative \\
        --options \$SHORTOPTS \\
        --longoptions \$LONGOPTS_WITH_ARG,\$LONGOPTS_WITHOUT_ARG \\
        -- \$*"
        ## If next command fails, we trap error
    echo -n "\$RED"
    OPTS="\$(eval "\$OPT_CMD")" || doErr "Arg parsing error" # Following seem to be correct \$OPTS"
    echo -n "\$RESET"

    # set the list of arguments equal to ${OPTS} : set them in proper order.
    eval set -- "\$OPTS"
    while true; do
        case "\$1" in
        -f | --file-name) #         ### filename to me "action"ed upon {Required}
            export FILE_NAME=\$2
            shift 2
            ;;

        -a | --action) #            ### Action to be taken in file (copy/move/link/rsync) {Optional: Default: copy }
            WHAT=\${2,,} # lower case
            #WHAT=\${2^^} # upper case
            case "\${WHAT}" in
                c*) ACTION="cp" ;;
                m*) ACTION="mv" ;;
                sc* | r*) ACTION="rsync" ;;
                l*) ACTION="ln -nfs" ;;
                *) ACTION="cp" ;;
            esac
            export ACTION
            shift; shift
            ;;

        -h | --help) #              ### Help
            #doErr "Help"
            usage
            shift
            ;;

        --) #                       ### options after -- are not parsed {can be passed on to some script later}
            #shift
            break
            ;;

        *)
            doWarn "Ignored option : \$1 \$2 "
            #shift
            break
            ;;

        # \?)
        #     doErr "Invalid options \$1 \$2 "
        #     break
        #     ;;

        esac
    done

    shopt -u nocasematch

    UNPARSED_OPTION="\$*"
    UNPARSED_OPTION_COUNT="\$#"
    echo $EXTRA_ARGS
    if [[ \$UNPARSED_OPTION_COUNT -gt 0 ]]; then
        # shellcheck disable=SC2001 ## See if you can use \${variable//search/replace} instead. 
        UNPARSED_OPTION="\$(echo "\$UNPARSED_OPTION" |& sed 's/-- //g')"   # reomve --
        UNPARSED_OPTION_COUNT="\$(echo "\$UNPARSED_OPTION" | sed 's/ /\n/g' |  wc -l)" #(can be simple -1 for the removed --)
        export UNPARSED_OPTION
        export UNPARSED_OPTION_COUNT
        doWarn "\$UNPARSED_OPTION_COUNT unparsed options  :\$UNPARSED_OPTION"
    fi

}

# _getOptCompletion() {
# 
#     getOptsOptions ## Call function
#     local shortOpts opts longOpts
#     shortOpts=\$(IFS=":" && echo \$SHORTOPTS)
#     IFS=" " && for each in \$shortOpts; do opts+="-\$each "; done
#     longOpts=\$(IFS=":," && echo \$LONGOPTS_WITH_ARG \$LONGOPTS_WITHOUT_ARG)
#     IFS=" " && for each in \$longOpts; do opts+="--\$each "; done
#     export ALL_OPTS=\$opts ## All valid opts
# 
#     local cur
#     COMPREPLY=() # Array variable storing the possible completions.
#     cur="\${COMP_WORDS[COMP_CWORD]}"
#     #prev="\${COMP_WORDS[COMP_CWORD-1]}"
# 
#     case "\$cur" in
#     -*)
#         COMPREPLY=(\$(compgen -W "\${ALL_OPTS}" -- \${cur}))
#         #echo \$COMPREPLY
#         ;;
#     esac
# 
#     return 0
# }


function main() {
    START_TIME=\$(date +%s)
    getOpt "\$@"

    echo "DO STUFF HERE" 

    END_TIME=\$(date +%s)
    DURATION=\$((END_TIME - START_TIME))
    displayTime \$DURATION
}

#complete -F _getOptCompletion -o "\$FILE"
main "\$@";
EOF