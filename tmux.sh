#!/bin/bash
# shellcheck disable=SC2086 

# Session Name
SESSION=$USER
SESSIONEXISTS=$(tmux list-sessions | grep $USER)

## As per tmux conf : session pane base starts with 1
SESSION_WINDOW_NUMBER=1

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    # Start New Session with our name
    tmux new-session -d -s $SESSION
    tmux rename-window -t 1 "$HOSTNAME"     # 1st window is current host

    for host in ru20-hw-linux125 in09sglab-zebu-lnx dhurd-hpz640-lnx de02arcssv-zs3-01 us01arcssv-zs4-01 us01odcvde13266 arcdev6; do
        if [[ "$HOSTNAME" != "$host" ]] ; then
        SESSION_WINDOW_NUMBER=$(( SESSION_WINDOW_NUMBER + 1 ))
        tmux new-window -t $SESSION:$SESSION_WINDOW_NUMBER -n "$host"
        tmux send-keys -t "$host" "ssh -Yt $USER@$host \"export DISPLAY=localhost:10.0 && exec bash -l\" " C-m 
        fi
    done

    #tmux select-pane -t $HOSTNAME       
    ## always start with current host pane
    tmux select-window -t $HOSTNAME
    #tmux split-window -h (prefix + %)


fi
#"commandline": "ssh -Yt hastakh@us01odcvde13266 \"export DISPLAY=localhost:10.0 && exec bash -l\" ",
# Attach Session, on the Main window
tmux attach-session -t $SESSION
