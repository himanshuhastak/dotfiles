#!/bin/bash
# shellcheck disable=SC2086

# Session Name
SESSION=$USER
SESSIONEXISTS=$(tmux list-sessions | grep $USER)

WORK_HOSTLIST="host1 "
WORK1_HOSTLIST="host2 host3 "

WORK2_HOSTLIST="host4 host5 "
shopt -s extglob
#Note: there should be no spaces : like '@(host1 | host2)'
MINICOM_HOSTS='@(host4|host5)'

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]; then
    # Start main Session with our name
    tmux new-session -d -s $SESSION

    # Start multiple other sessions
    for session in WORK  WORK1 WORK2 ;do
        tmux new-session -d -s $session
        tmux switch -t $session
        tmux rename-window -t 1 "$HOSTNAME" # 1st window is current host
        SESSION_WINDOW_NUMBER=1

        case $session in
        WORK)
            HOSTLIST=$WORK_HOSTLIST
            ;;
        WORK1)
            HOSTLIST=$WORK1_HOSTLIST
            ;;
        WORK2)
            HOSTLIST=$WORK2_HOSTLIST
            ;;
        esac

        for host in $HOSTLIST; do
            if [[ "$HOSTNAME" != "$host" ]]; then
                SESSION_WINDOW_NUMBER=$((SESSION_WINDOW_NUMBER + 1))
                tmux new-window -t $session:$SESSION_WINDOW_NUMBER -n "$host"
                tmux send-keys -t "$host" "ssh -Yt $USER@$host \"export DISPLAY=:51 && exec bash -l\" " C-m
            fi

            case $host in
            ${MINICOM_HOSTS})
                SPLIT_RATIO=40
                tmux split-window -h -p $SPLIT_RATIO
                #!if we lock minicom other people cant use it, be careful what you wish for or do not lock -o/--noinit
                tmux send-keys "ssh -Yt $USER@$host \"export DISPLAY=:51 && minicom -b 115200 --noinit -D /dev/haps-serial  || exec bash -l\" " C-m
                ## As per tmux conf : session pane base ,window base starts with 1; set it as default
                tmux select-pane -t 1 # This is where we have original ssh'd host, not yhe new minicom'd pane
                ;;
            default) ;;
            esac

        done
    done

    ## always start with main host pane as default
    tmux switch -t $SESSION
    tmux select-window -t 1
    tmux select-pane -t 1

fi

# Attach Session, on the Main window if exists
tmux attach-session -t $SESSION
