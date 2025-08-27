#!/bin/bash
set -e

SOCKET_NAMES="druid amazeeio"
SOCKET_FOUND=0

for i in ${SOCKET_NAMES}
do
   :
   SOCKET="/tmp/${i}_ssh-agent/socket"

   if [ -S "${SOCKET}" ]; then
    echo "- Found socket from ${SOCKET}"
    echo "- Symlink ${SSH_AUTH_SOCK} to ${SOCKET}..."
    ln -sf "${SOCKET}" "$SSH_AUTH_SOCK"
    SOCKET_FOUND=1
  fi
done

if [ ${SOCKET_FOUND} = 0 ]; then
  echo "- No socket found"
fi
