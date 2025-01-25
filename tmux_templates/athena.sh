#!/bin/bash
# Setup terminal windows and panes for athena development

set -e
trap 'echo "Error on line $LINENO"; exit 1' ERR

session='athena'

# Start a new tmux session (detatched for now) OR attach to existing session
tmux new-session -d -s $session &> /dev/null || { 
	tmux send-keys -t $session:1.1 "echo \"Attached to existing $session session\"" C-m
	tmux switch-client -t $session:1.1
	exit
}

# Window 1: In ~/github/AthenaInstruments with two panes side by side
# tmux rename-window -t mysession:1 ''
tmux send-keys -t $session:1 'cd ~/github/AthenaInstruments' C-m
tmux split-window -h -t $session:1

# Window 2: Named 'dotfiles' with nvim open in ~/dotfiles directory
tmux new-window -t $session:2 -n 'dotfiles'
tmux send-keys -t $session:2 'cd ~/dotfiles && nvim' C-m

# Window 3: Named 'remote'
tmux new-window -t $session:3 -n 'remote'

# Attach to the session
tmux send-keys -t $session:1.1 'echo "Session setup complete"' C-m
tmux switch-client -t $session:1.1
