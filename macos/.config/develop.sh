#!/bin/sh
# dev-session.sh — open a tmux dev environment for the current project
# Usage: dev [path]  (defaults to current directory)

dir="${1:-$(pwd)}"
session="$(basename "$dir" | tr '.:' '-')"

cd "$dir" || exit 1

attachOrSwitch() {
  if [ -n "$TMUX" ]; then
    exec tmux switch-client -t "$session"
  else
    exec tmux attach-session -t "$session"
  fi
}

# Reattach if session already exists
if tmux has-session -t "$session" 2>/dev/null; then
  attachOrSwitch
fi

tmux new-session -s "$session" -n "nvim" -c "$dir" -d
tmux send-keys -t "$session:nvim" "nvim ." Enter

tmux new-window -d -t "$session" -n "claude" -c "$dir"
tmux send-keys -t "$session:claude" "claude" Enter

tmux new-window -d -t "$session" -n "git" -c "$dir"
tmux send-keys -t "$session:git" "lazygit" Enter

tmux new-window -d -t "$session" -n "server" -c "$dir"
tmux new-window -d -t "$session" -n "scratch" -c "$dir"

tmux select-window -t "$session:nvim"

attachOrSwitch
