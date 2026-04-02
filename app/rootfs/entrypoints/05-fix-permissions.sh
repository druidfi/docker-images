#!/bin/bash

FILES_DIR=/app/public/sites/default/files

if [ -d "${FILES_DIR}" ]; then
  if find "${FILES_DIR}" -not -user www-data -print -quit 2>/dev/null | grep -q .; then
    echo "Fix ownership of ${FILES_DIR}..."
    doas chown -R www-data:www-data "${FILES_DIR}"
  fi
fi
