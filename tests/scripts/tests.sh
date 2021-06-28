#!/usr/bin/env bash

neofetch

. "$(dirname "$0")/utils.sh"
. "$(dirname "$0")/perms.sh"
. "$(dirname "$0")/php.sh"

echo -e "\n\e[30;42mAll tests passed!\e[49m\n"

exit 0
