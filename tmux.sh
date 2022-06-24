#!/bin/bash
# shellcheck disable=SC2086
# shellcheck disable=SC2254

# Session Name
SESSION=$USER
SESSIONEXISTS=$(tmux list-sessions | grep $USER)
HOSTLIST="host1 host2 host3"
shopt -s extglob
#Note: there should be no spaces : like '@(host1 | host2)'
MINICOM_HOSTS='@(host1|host2)'

## As per tmux conf : session pane base ,window base starts with 1
SESSION_WINDOW_NUMBER=1

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]; then
    # Start New Session with our name
    tmux new-session -d -s $SESSION
    tmux rename-window -t 1 "$HOSTNAME" # 1st window is current host

    for host in $HOSTLIST; do
        if [[ "$HOSTNAME" != "$host" ]]; then
            SESSION_WINDOW_NUMBER=$((SESSION_WINDOW_NUMBER + 1))
            tmux new-window -t $SESSION:$SESSION_WINDOW_NUMBER -n "$host"
            tmux send-keys -t "$host" "ssh -Yt $USER@$host \"export DISPLAY=localhost:10.0 && exec bash -l\" " C-m

            case $host in
            ${MINICOM_HOSTS})
            SPLIT_RATIO=${SPLIT_RATIO:-25}
                tmux split-window -h -p $SPLIT_RATIO
                #!if we lock minicom other people cant use it, be careful what you wish for or do not lock -o/--noinit
                tmux send-keys "ssh -Yt $USER@$host \"export DISPLAY=localhost:10.0  && minicom -b 115200 --noinit -D /dev/haps-serial  || exec bash -l\" " C-m
                ## As per tmux conf : session pane base ,window base starts with 1; set it as default
                tmux select-pane -t 1
                ;;
            default) ;;
            esac
        fi
    done

    ## always start with current host pane as default
    tmux select-window -t $HOSTNAME

fi

# Attach Session, on the Main window if exists
tmux attach-session -t $SESSION
