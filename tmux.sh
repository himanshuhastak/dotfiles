#!/bin/bash

# Session Name
SESSION=$USER
SESSIONEXISTS=$(tmux list-sessions | grep $USER)

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    # Start New Session with our name
    tmux new-session -d -s $SESSION

    ## As per tmux conf : session pane base starts with 1
    tmux rename-window -t 1 'ru20-HAPS'
    tmux send-keys -t 'ru20-HAPS' 'ssh -Yt ru20-hw-linux125' C-m 'bash' C-m

    tmux new-window -t $SESSION:2 -n 'de02-zs3'
    tmux send-keys -t 'de02-zs3' 'ssh -Yt hastakh@de02arcssv-zs3-01' C-m

    tmux new-window -t $SESSION:3 -n 'us01-zs4'
    tmux send-keys -t 'us01-zs4' 'ssh -Yt hastakh@us01arcssv-zs4-01' C-m

    tmux new-window -t $SESSION:4 -n 'arcdev6'
    tmux send-keys -t 'arcdev6' 'ssh -Yt hastakh@arcdev6' C-m

    tmux new-window -t $SESSION:5 -n 'us01-vde'
    #tmux send-keys -t 'us01-vde' 'clear' C-m

    # tmux select-pane -t 1

fi
#"commandline": "ssh -Yt hastakh@us01odcvde13266 \"export DISPLAY=localhost:10.0 && exec bash -l\" ",
# Attach Session, on the Main window
tmux attach-session -t $SESSION
