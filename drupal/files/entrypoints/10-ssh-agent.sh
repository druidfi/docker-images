#!/bin/sh
set -e

# Test if ssh-agents are mounted and symlink them as our known ssh-auth-sock file.
# This will only be used in local development
if [ -S /tmp/amazeeio_ssh-agent/socket ]; then
  echo "Found socket from /tmp/amazeeio_ssh-agent/socket"
  echo "Symlink $SSH_AUTH_SOCK to /tmp/amazeeio_ssh-agent/socket..."
  ln -sf /tmp/amazeeio_ssh-agent/socket "$SSH_AUTH_SOCK"
else
  echo "No socket found from /tmp/amazeeio_ssh-agent/socket"
fi
