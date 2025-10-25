#!/usr/bin/env bash

sleep 1

neofetch --ascii_colors 1 --ascii /app/scripts/ascii

. "$(dirname "$0")/utils.sh"
. "$(dirname "$0")/perms.sh"
. "$(dirname "$0")/php.sh"
. "$(dirname "$0")/db.sh"

echo -e "\n\e[30;42mAll tests passed!\e[49m\n"

exit 0
