#!/usr/bin/env bash
# wsl-ssh-agent.sh - expose Windows ssh-agent inside WSL2 via npiperelay + socat

# Guard: ensure this file is sourced, not executed
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "This file must be sourced, not executed." >&2
  exit 1
fi

# Path to npiperelay.exe as seen from WSL.
# Adjust this or set NPIPERELAY_EXE in your env if needed.
NPIPERELAY_EXE="${NPIPERELAY_EXE:-/mnt/c/Users/davide/.ssh/npiperelay.exe}"

# Windows OpenSSH agent named pipe
WIN_AGENT_PIPE='//./pipe/openssh-ssh-agent'
# If you use Pageant instead, change to:
# WIN_AGENT_PIPE='//./pipe/pageant'

# Unix socket that WSL will use
SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/agent.sock}"
PIDFILE="$HOME/.ssh/agent-wsl2-socat.pid"

mkdir -p "$(dirname "$SSH_AUTH_SOCK")"

if ! command -v socat >/dev/null 2>&1; then
    echo "Error: socat not found. Install it with: sudo apt install socat" >&2
    return 1
fi

if [ ! -x "$NPIPERELAY_EXE" ]; then
    echo "Error: npiperelay.exe not found or not executable at:" >&2
    echo "  $NPIPERELAY_EXE" >&2
    echo "Set NPIPERELAY_EXE to the correct path and retry." >&2
    return 1
fi

# If an old socat is running, stop it
if [ -f "$PIDFILE" ]; then
    oldpid="$(cat "$PIDFILE" 2>/dev/null || true)"
    if [ -n "${oldpid:-}" ] && kill -0 "$oldpid" 2>/dev/null; then
        kill "$oldpid" || true
    fi
    rm -f "$PIDFILE"
fi

rm -f "$SSH_AUTH_SOCK"

# Start socat in the background, bridging the Unix socket to the Windows agent pipe
socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:"$NPIPERELAY_EXE -ei -s $WIN_AGENT_PIPE",nofork &
echo $! >"$PIDFILE"

# Export for the current shell (if sourced)
export SSH_AUTH_SOCK

echo "WSL ssh-agent bridge running."
echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
