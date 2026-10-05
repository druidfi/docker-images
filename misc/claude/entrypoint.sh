#!/bin/bash
if [ -n "$PINCHTAB_EXTRA_DOMAINS" ]; then
    jq --argjson domains "$(echo "$PINCHTAB_EXTRA_DOMAINS" | jq -R 'split(",")')" \
        '.security.idpi.allowedDomains += $domains' \
        ~/.pinchtab/config.json > /tmp/pinchtab-config.json && \
        mv /tmp/pinchtab-config.json ~/.pinchtab/config.json
fi
pinchtab server &>/tmp/pinchtab-server.log &
exec claude "$@"
