#!/usr/bin/env bash

sleep 1

fastfetch --config /home/druid/.config/fastfetch/config.jsonc

. "$(dirname "$0")/utils.sh"
. "$(dirname "$0")/perms.sh"
. "$(dirname "$0")/php.sh"
. "$(dirname "$0")/db.sh"

echo -e "\n\e[30;42mAll tests passed!\e[49m\n"

exit 0
