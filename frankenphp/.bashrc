#!/bin/sh

# Prompt with fire
if [ "$PS1" ]; then
  NORMAL="\[\e[0m\]"
  RED="\[\e[1;31m\]"
  YELLOW="\[\e[1;33m\]"
  PS1="🔥 ${YELLOW}[${APP_ENV:-Unknown}] ${RED}[${HOSTNAME}] ${YELLOW}\w${NORMAL} $ "
fi

# Aliases
alias ll="ls -lah"
alias make="make -s"

# Run fastfetch on login
fastfetch --config /root/.config/fastfetch/all.jsonc
