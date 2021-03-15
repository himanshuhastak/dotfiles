#!/bin/sh

# Set Session Name
SESSION="$USER"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    # Start New Session with our name
    tmux new-session -d -s $SESSION

    ## As per tmux conf : session pane base starts with 1
    tmux rename-window -t 1 'ru20'
    tmux send-keys -t 'ru20' 'ssh -Yt ru20-hw-linux125' C-m 'bash' C-m

    tmux new-window -t $SESSION:2 -n 'de02'
    tmux send-keys -t 'de02' 'ssh -Yt hastakh@de02arcssv-zs3-01' C-m # Switch to bind script?

    tmux new-window -t $SESSION:3 -n 'us01'
    tmux send-keys -t 'us01' 'clear' C-m # Switch to bind script?

    # tmux select-pane -t 1

fi

# Attach Session, on the Main window
tmux attach-session -t $SESSION