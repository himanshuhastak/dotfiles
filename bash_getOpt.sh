#! /usr/bin/env bash
# ------------------------------------------------
# Author:       hastakh
# Created:      Thu Mar 25 13:47:44 IST 2021
#
# Modifier:     hastakh
# Modified:     Thu Mar 25 13:47:44 IST 2021
#
# Usage:
#       $(basename $0) --help
#
# Description:
#       bash wrapper for getOpt
#
# Tool Versions:
#       getopt from util-linux 2.23.2 or later
# ------------------------------------------------
# shellcheck disable=SC2086 ## Double quote to prevent globbing and word splitting.
# shellcheck disable=SC2046 ## Quote this to prevent word splitting.        #useful in $(find ......)
# shellcheck disable=SC1090 ## Can't follow non-constant source. Use a directive to specify location.
# shellcheck disable=SC1091 ## Not following: <filename> was not specified as input (see shellcheck -x).

#set -o xtrace      # set -x
#set -o errexit     # set -e : Used to exit upon error, avoiding cascading errors
#set -o pipefail    # Unveils hidden failures
#set -o nounset
# 2>&1         # Redirrect stderr to stdout
#IFS=$'\n\t'

export FILE="${0##*/}"
export CUR_DIR=$PWD
export SCRIPTS_DIR="${0%/*}"
#source "${SCRIPTS_DIR}/foo.sh"

function clean_up() {
    doErr "Aborted by signal"
}
trap clean_up SIGHUP SIGINT SIGTERM

traperr() {
    doErr "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap traperr ERR

function displayTime {
    local T=$1
    local D=$((T / 60 / 60 / 24))
    local H=$((T / 60 / 60 % 24))
    local M=$((T / 60 % 60))
    local S=$((T % 60))
    [[ $D -gt 0 ]] && printf '%d days ' $D
    [[ $H -gt 0 ]] && printf '%d hours ' $H
    [[ $M -gt 0 ]] && printf '%d minutes ' $M
    [[ $D -gt 0 || $H -gt 0 || $M -gt 0 ]] && printf 'and '
    printf '%d seconds\n' $S
}

function colors() {

    RED=$(tput setaf 1)
    YELLOW=$(tput setaf 3)
    MAGENTA=$(tput setaf 5)
    # DIM=$(tput dim)
    START_UNDERLINE=$(tput smul)
    END_UNDERLINE=$(tput rmul)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)

    export RED
    export YELLOW
    export MAGENTA
    # export DIM
    export START_UNDERLINE
    export END_UNDERLINE
    export BOLD
    export RESET

}

function usage() {
    colors
    set +x
    echo -e $MAGENTA $START_UNDERLINE
    echo usage:
    echo -e $END_UNDERLINE $RESET

    grep "[[:space:]].*-.*)[[:space:]].*" $FILE |
        sed 's/###//g' | sed '/grep/d'
    set +x
}

function doErr() {
    echo -e "$RED $DIM [ERROR_INFO]: $RED $* $RESET" 1>&2
    usage
    exit 1
}

function doWarn() {
    echo -e "$YELLOW $DIM [WARNING_INFO]: $YELLOW $* $RESET" 1>&2
}

function getOpts_Options() {

    # single colon ':' means that it argument is required.
    # double colons '::' means that its argument is optional.
    export SHORTOPTS="f:d:s:a:h"
    #export SHORTOPTS="f:d:s::a::h"    ## find out why :: does not work
    export LONGOPTS_WITH_ARG="file-name:,host-destination:,host-src:,host-source:,source:,src:,destination:,action:"
    export LONGOPTS_WITHOUT_ARG="help"

    local shortOpts opts longOpts
    shortOpts=$(IFS=":" && echo $SHORTOPTS)
    IFS=" " && for each in $shortOpts; do opts+="-$each "; done
    longOpts=$(IFS=":," && echo $LONGOPTS_WITH_ARG $LONGOPTS_WITHOUT_ARG)
    IFS=" " && for each in $longOpts; do opts+="--$each "; done
    export ALL_OPTS=$opts ## All valid opts
}

_getOptCompletion() {
    getOpts_Options ## Call function
    local cur
    COMPREPLY=() # Array variable storing the possible completions.
    cur="${COMP_WORDS[COMP_CWORD]}"
    #prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "$cur" in
    -*)
        COMPREPLY=($(compgen -W "${ALL_OPTS}" -- ${cur}))
        #echo $COMPREPLY
        ;;
    esac

    return 0
}

function getOpt() {

    colors
    shopt -s nocasematch

    [ $# -eq 0 ] && doErr "No Options Passed"
    getOpts_Options ## Call function

    OPT_CMD="getopt --alternative \
        --options $SHORTOPTS \
        --longoptions $LONGOPTS_WITH_ARG,$LONGOPTS_WITHOUT_ARG \
        -- $*"
    echo -n $RED
    OPTS=$(eval $OPT_CMD) || doErr "Following seem to be correct $OPTS"
    echo -n $RESET

    # # set the list of arguments equal to ${OPTS} : set them in proper order.
    # eval set -- "$OPTS"
    while true; do
        # while (( "$#" )); do
        # while [ ! -z "$1" ]; do
        case "$1" in
        -f | --file-name) ### filename to me "action"ed upon {Required}
            FILE_NAME=$2
            shift 2
            ;;
        -s | --source | --sr*) ### Source Dir of file  {Optional: Default .}
            case "$2" in
            "")
                SOURCE_DIR='.'
                shift 2
                ;;
            *)
                SOURCE_DIR=$2
                shift 2
                ;;
            esac
            ;;
        -d | --destination | --des*) ### Destination Dir {Required}
            DESTINATION_DIR=$2
            shift 2
            ;;
        -a | --action)  ### Action to be taken in file (copy/move/link/rsync) {Optional: Default: copy }
            WHAT=${2,,} # lower case
            #WHAT=${2^^} # upper case
            case "${WHAT}" in
            c*) ACTION="cp" ;;
            m*) ACTION="mv" ;;
            sc* | r*) ACTION="rsync" ;;
            l*) ACTION="ln -nfs" ;;
            *) ACTION="cp" ;;
            esac
            shift 2
            ;;
        --host-s*) ### source HOSTNAME for scp/rsync
            export SRC_HOST=$2
            shift
            shift
            ;;

        --host-d*) ### destination HOSTNAME for scp/rsync
            export DEST_HOST=$2
            shift
            shift
            ;;

        -h | --help) ### Help
            doErr "Help"
            shift
            ;;

        --) ### options after -- are not parsed {can be passed on to some script later}
            #EXTRA_ARGS+="$1"
            break
            ;;

        *)
            #POSITIONAL+="$1"
            doWarn "Ignored Invalid option : $1 $2 "
            #shift
            break
            ;;

            # \?)
            #     doErr "Invalid options $1 $2 "
            #     break
            #     ;;

        esac
    done

    shopt -u nocasematch

    UNPARSED_OPTION="$*"
    UNPARSED_OPTION_COUNT="$#"
    echo $EXTRA_ARGS
    if [[ $UNPARSED_OPTION_COUNT -gt 0 ]]; then
        # export UNPARSED_OPTION=$(echo $UNPARSED_OPTION |& sed 's/-- //g')   # reomve --
        # export UNPARSED_OPTION_COUNT=$(echo $UNPARSED_OPTION | sed 's/ /\n/g' |  wc -l) #(can be simple -1 for the removed --)
        doWarn "$UNPARSED_OPTION_COUNT unparsed options  : $UNPARSED_OPTION"
        ### Process the unparsed options as positional &| extra args
    fi
    #echo $ALL_OPTS
}

function main() {
    START_TIME=$(date +%s)
    getOpt "$@"

    #echo "$ALL_OPTS"
    echo "$ACTION file $FILE_NAME from $SRC_HOST $SOURCE_DIR to $DEST_HOST $DESTINATION_DIR"

    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    displayTime $DURATION
}

#complete -F _getOptCompletion
complete -F getOptCompletion -o filenames $FILE
main "$@"

# while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
#   -V | --version )
#     echo $version
#     exit
#     ;;
#   -s | --string )
#     shift; string=$1
#     ;;
#   -f | --flag )
#     flag=1
#     ;;
# esac; shift; done
# if [[ "$1" == '--' ]]; then shift; fi
