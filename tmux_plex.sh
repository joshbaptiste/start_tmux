#!/usr/bin/env bash
#
# Setup a work space called `work` with two windows
# first window has 2 panes.
# The first pane set at 50%, split horizontally,
# window 2 is split at 80%
# window 3 is set to bash prompt.
#
session="plexs"
# Exit if in a tmux session already
[[ -n $TMUX ]] &&  echo "Please exit this tmux session " && exit 
# If session is already there simply attach and exit script
if tmux list-session -F '#{session_name}' | grep -q $session
then
    tmux attach-session -t $session
    exit 0
fi

function create_session() {
    # set up tmux
    tmux start-server
    # create a new tmux session named $session, and name first window otfsh
    tmux new-session -d -s $session -n plexter
    #List the window indexes and get the first one
    #first_index=$(tmux list-windows -F '#{window_index}' | head -n1)
}

function window1(){
    # Split the first called '{start}' window/pane with a horizontal line by 50%
    tmux split-window -v -t $session:'{start}'
    # Select pane 0 (The top)
    tmux select-pane -t '{top}'
    tmux send-keys -t $session:'{start}' "ssh plexter" C-m
    # Select pane 1 (The bottom)
    tmux select-pane -t '{bottom}'
    #login to otfsh PDT (C-m sends carriage return)
    tmux send-keys -t '{bottom}' "ssh plexter2" C-m
    # Split the first called '{start}' window/pane with a horizontal line by 50%
    tmux split-window -h -t $session:'{start}'
    tmux send-keys -t $session:'{start}' "ssh plexter1x" C-m
}

function window2(){
    # Create a another window named bash
    tmux new-window -t $session:'{next}' -n bash
     # Split window/pane 0 with a horizontal line by 20%
    #tmux split-window -t $session:'{next}' -v -p 20
    # Select pane 0 (The top)
    #tmux select-pane -t '{top}'
}

function window3(){
    # Create a another window named bash
    tmux new-window -t $session
}

function attach(){
    # return to main otfsh window
    tmux select-window -t $session:'{start}'
    # Finished setup, attach to the tmux session!
    tmux attach-session -t $session
}

#Main
create_session
window1
#window2
#window3
#attach
